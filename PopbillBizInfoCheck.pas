(*
*=================================================================================
* Unit for base module for Popbill API SDK. It include base functionality for
* RESTful web service request and parse json result. It uses Linkhub module
* to accomplish authentication APIs.
*
* http://www.popbill.com
* Author : Choi sh (code@linkhubcorp.com)
* Written : 2022-10-05
* Thanks for your interest.
*=================================================================================
*)
unit PopbillBizInfoCheck;

interface

uses
        TypInfo,SysUtils,Classes,
        Popbill, Linkhub;
type
        TBizInfoCheckChargeInfo = class
        public
                unitCost : string;
                chargeMethod : string;
                rateSystem : string;
        end;
        
        TBizCheckInfo = class
        public
                corpNum : string;
                checkDT : string;
                corpName : string;
                corpCode : string;
                corpScaleCode : string;
                personCorpCode : string;
                headOfficeCode : string;
                industryCode : string;
                companyRegNum : string;
                establishDate : string;
                establishCode : string;
                ceoname : string;
                workPlaceCode : string;
                addrCode : string;
                zipCode : string;
                addr : string;
                addrDetail : string;
                enAddr : string;
                bizClass : string;
                bizType : string;
                result : string;
                resultMessage : string;
                closeDownTaxType : string;
                closeDownTaxTypeDate : string;
                closeDownState : string;
                closeDownStateDate : string;
        end;

        TBizInfoCheckService = class(TPopbillBaseService)
        private
                function jsonToTBizCheckInfo(json : String) : TBizCheckInfo;

        public
                constructor Create(LinkID : String; SecretKey : String);
                function GetUnitCost(CorpNum : String): Single;
                function checkBizInfo(MemberCorpNum : String; CheckCorpNum : String; UserID : String = '') : TBizCheckInfo;
                function GetChargeInfo(CorpNum : String) : TBizInfoCheckChargeInfo;
        end;

implementation

constructor TBizInfoCheckService.Create(LinkID : String; SecretKey : String);
begin
       inherited Create(LinkID,SecretKey);
       AddScope('171');
end;

function TBizInfoCheckService.GetUnitCost(CorpNum : String) : Single;
var
        responseJson : string;
begin
        try
                responseJson := httpget('/BizInfo/UnitCost',CorpNum,'');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code, le.message);
                                exit;
                        end
                        else
                        begin
                                result := 0.0;
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
                result := strToFloat(getJSonString( responseJson,'unitCost'));
        end;
end;


function TBizInfoCheckService.GetChargeInfo(CorpNum : string) : TBizInfoCheckChargeInfo;
var
        responseJson : String;
begin
        try
                responseJson := httpget('/BizInfo/ChargeInfo',CorpNum,'');
        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.message);
                                exit;
                        end
                        else
                        begin
                                result := TBizInfoCheckChargeInfo.Create;
                                setLastErrCode(le.code);
                                setLastErrMessage(le.message);
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
                try
                        result := TBizInfoCheckChargeInfo.Create;
                        result.unitCost := getJSonString(responseJson, 'unitCost');
                        result.chargeMethod := getJSonString(responseJson, 'chargeMethod');
                        result.rateSystem := getJSonString(responseJson, 'rateSystem');
                except
                        on E:Exception do begin
                                if FIsThrowException then
                                begin
                                        raise EPopbillException.Create(-99999999,'결과처리 실패.[Malformed Json]');
                                        exit;
                                end
                                else
                                begin
                                        result := TBizInfoCheckChargeInfo.Create;
                                        setLastErrCode(-99999999);
                                        setLastErrMessage('결과처리 실패.[Malformed Json]');
                                        exit;
                                end;
                        end;
                end;
        end;
end;



function TBizInfoCheckService.checkBizInfo(MemberCorpNum : String; CheckCorpNum : String; UserID : String = '') : TBizCheckInfo;
var
        responseJson : string;
        url : string;
begin
        if Length(MemberCorpNum) = 0 then
        begin
                if FIsThrowException then
                begin
                        raise EPopbillException.Create(-99999999, '조회할 사업자번호가 입력되지 않았습니다');
                        Exit;
                end
                else
                begin
                        result := TBizCheckInfo.Create;
                        setLastErrCode(-99999999);
                        setLastErrMessage('조회할 사업자번호가 입력되지 않았습니다');
                        exit;
                end;
        end;

        url := '/BizInfo/Check?CN='+ CheckCorpNum;

        try
                responseJson := httpget(url, MemberCorpNum, UserID);

        except
                on le : EPopbillException do begin
                        if FIsThrowException then
                        begin
                                raise EPopbillException.Create(le.code,le.message);
                                exit;
                        end
                        else
                        begin
                                result := TBizCheckInfo.Create;
                                exit;
                        end;
                end;
        end;

        if LastErrCode <> 0 then
        begin
                exit;
        end
        else
        begin
                result := jsonToTBizCheckInfo(responseJson);
        end;        
end;

function TBizInfoCheckService.jsonToTBizCheckInfo(json : String) : TBizCheckInfo;
begin
        result := TBizCheckInfo.Create;
        result.corpNum := getJsonString(json,'corpNum');
        result.checkDT := getJsonString(json,'checkDT');
        result.corpName := getJsonString(json,'corpName');
        result.corpCode := getJsonString(json,'corpCode');
        result.corpScaleCode := getJsonString(json,'corpScaleCode');
        result.personCorpCode := getJsonString(json,'personCorpCode');
        result.headOfficeCode := getJsonString(json,'headOfficeCode');
        result.industryCode := getJsonString(json,'industryCode');
        result.companyRegNum := getJsonString(json,'companyRegNum');
        result.establishDate := getJsonString(json,'establishDate');
        result.establishCode := getJsonString(json,'establishCode');
        result.ceoname := getJsonString(json,'ceoname');
        result.workPlaceCode := getJsonString(json,'workPlaceCode');
        result.addrCode := getJsonString(json,'addrCode');
        result.zipCode := getJsonString(json,'zipCode');
        result.addr := getJsonString(json,'addr');
        result.addrDetail := getJsonString(json,'addrDetail');
        result.enAddr := getJsonString(json,'enAddr');
        result.bizClass := getJsonString(json,'bizClass');
        result.bizType := getJsonString(json,'bizType');
        result.result := getJsonString(json,'result');
        result.resultMessage := getJsonString(json,'resultMessage');
        result.closeDownTaxType := getJsonString(json,'closeDownTaxType');
        result.closeDownTaxTypeDate := getJsonString(json,'closeDownTaxTypeDate');
        result.closeDownState := getJsonString(json,'closeDownState');
        result.closeDownStateDate := getJsonString(json,'closeDownStateDate');
end;


//End Of Unit.
end.
 