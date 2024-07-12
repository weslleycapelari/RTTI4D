unit RTTI4D.Method;

interface

uses
  RTTI4D.Intf,
  RTTI4D.Exceptions,
  RTTI4D.Enum,
  System.Rtti,
  System.Math,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Variants;

type
  TRTTI4DMethod = class(TInterfacedPersistent, IRTTI4DMethod)
  private
    FSilent: Boolean;
    FResult: TValue;
    FParent: IRTTI4DObject;
    FExecuted: Boolean;
    FRttiMethod: TRttiMethod;
    FMethod: TRttiMethod;

    FName: string;
    FType: TRTTI4DMethodType;
    FVisibility: TRTTI4DVisibility;

    procedure Update;
    function VerifyMethod(AParams: TArray<TValue>): Boolean;
    function MethodExists(AParams: TArray<TValue>): Boolean;
    function GetMethodByParams(AParams: TArray<TValue>): TRttiMethod;

    constructor Create(const ARttiMethod: TRttiMethod;
      AObject: IRTTI4DObject); overload;
    constructor Create(const AMethodName: string;
      AObject: IRTTI4DObject); overload;
  public
    class function New(const ARttiMethod: TRttiMethod;
      AObject: IRTTI4DObject): IRTTI4DMethod; overload;
    class function New(const AMethodName: string;
      AObject: IRTTI4DObject): IRTTI4DMethod; overload;

    function Parent: IRTTI4DObject;

    function Silent: Boolean; overload;
    function Silent(const AValue: Boolean): IRTTI4DMethod; overload;
    function Name: string;
    function Visibility: TRTTI4DVisibility;
    function MethodType: TRTTI4DMethodType;
    function Result: TValue;
    function Executed: Boolean;
    function Call: IRTTI4DMethod; overload;
    function Call(AParams: array of const): IRTTI4DMethod; overload;
    function Call(AParams: TArray<TValue>): IRTTI4DMethod; overload;
    function Call(AParams: TArray<Variant>): IRTTI4DMethod; overload;

    function Attributes: TArray<TCustomAttribute>;
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

implementation

{ TRTTI4DMethod }

constructor TRTTI4DMethod.Create(const ARttiMethod: TRttiMethod;
  AObject: IRTTI4DObject);
begin
  inherited Create;
  FRttiMethod := ARttiMethod;
  FParent     := AObject;
  FSilent     := AObject.Silent;
  FResult     := TValue.Empty;
  FExecuted   := False;

  Update;
end;

function TRTTI4DMethod.Attributes: TArray<TCustomAttribute>;
begin
  Result := FRttiMethod.GetAttributes;
end;

function TRTTI4DMethod.Call(AParams: TArray<Variant>): IRTTI4DMethod;
var
  LParams: TArray<TValue>;
  LCount : Integer;
begin
  Result := Self;

  SetLength(LParams, Length(AParams));
  for LCount := Low(AParams) to High(AParams) do
    LParams[LCount] := TValue.FromVariant(AParams[LCount]);
  Call(LParams);
end;

function TRTTI4DMethod.Call: IRTTI4DMethod;
var
  LArray: TArray<Variant>;
begin
  Result := Call(LArray);
end;

function TRTTI4DMethod.Call(AParams: TArray<TValue>): IRTTI4DMethod;
var
  LObject: TObject;
begin
  Result := Self;

  if VerifyMethod(AParams) then
  begin
    FResult := TValue.Empty;
    FExecuted := False;
    try
      LObject := TObject(FParent.RefInstance^);
      if LObject = nil then
        FResult := FMethod.Invoke(FParent.RefClass, AParams)
      else
        FResult := FMethod.Invoke(LObject, AParams);
      FExecuted := True;
    except
      if not FSilent then
        raise;
    end;
  end;
end;

function TRTTI4DMethod.Call(AParams: array of const): IRTTI4DMethod;
var
  LParams: TArray<TValue>;
  LCount : Integer;
begin
  Result := Self;

  SetLength(LParams, Length(AParams));
  for LCount := Low(AParams) to High(AParams) do
    LParams[LCount] := TValue.FromVarRec(AParams[LCount]);
  Call(LParams);
end;

constructor TRTTI4DMethod.Create(const AMethodName: string;
  AObject: IRTTI4DObject);
begin
  inherited Create;
  FRttiMethod := nil;
  FName       := AMethodName;
  FType       := mtUnknown;
  FParent     := AObject;
  FSilent     := AObject.Silent;
  FResult     := TValue.Empty;
  FExecuted   := False;
end;

function TRTTI4DMethod.Executed: Boolean;
begin
  Result := FExecuted;
end;

function TRTTI4DMethod.GetAttribute(
  const AClass: TCustomAttributeClass): TCustomAttribute;
begin
  Result := FRttiMethod.GetAttribute(AClass);
end;

function TRTTI4DMethod.GetMethodByParams(AParams: TArray<TValue>): TRttiMethod;
var
  LMethod: TRttiMethod;

  function VerifyMethodParams(const ARttiMethod: TRttiMethod): Boolean;
  var
    LParam: TRttiParameter;
    LCount: Integer;
  begin
    Result := False;

    LCount := 0;
    for LParam in LMethod.GetParameters do
    begin
      if Length(AParams) = LCount then
        Break;

      if LParam.ParamType.TypeKind <> AParams[LCount].Kind then
        Break;

      Inc(LCount);
    end;

    if Length(AParams) > LCount then
      Exit;

    Result := True;
  end;
begin
  Result  := nil;
  FMethod := nil;

  for LMethod in FParent.RttiType.GetMethods(FName) do
  begin
    if Length(LMethod.GetParameters) < Length(AParams) then
      Continue;

    if not VerifyMethodParams(LMethod) then
      Continue;

    FMethod := LMethod;
    Exit(FMethod);
  end;
end;

function TRTTI4DMethod.HasAttribute(
  const AClass: TCustomAttributeClass): Boolean;
begin
  Result := FRttiMethod.HasAttribute(AClass);
end;

function TRTTI4DMethod.MethodExists(AParams: TArray<TValue>): Boolean;
begin
  Result := False;

  if GetMethodByParams(AParams) <> nil then
    Result := True;
end;

function TRTTI4DMethod.MethodType: TRTTI4DMethodType;
begin
  Result := FType;
end;

function TRTTI4DMethod.Name: string;
begin
  Result := FName;
end;

class function TRTTI4DMethod.New(const ARttiMethod: TRttiMethod;
  AObject: IRTTI4DObject): IRTTI4DMethod;
begin
  Result := TRTTI4DMethod.Create(ARttiMethod, AObject);
end;

class function TRTTI4DMethod.New(const AMethodName: string;
  AObject: IRTTI4DObject): IRTTI4DMethod;
begin
  Result := TRTTI4DMethod.Create(AMethodName, AObject);
end;

function TRTTI4DMethod.Parent: IRTTI4DObject;
begin
  Result := FParent;
end;

function TRTTI4DMethod.Result: TValue;
begin
  Result := FResult;
end;

function TRTTI4DMethod.Silent(const AValue: Boolean): IRTTI4DMethod;
begin
  Result  := Self;
  FSilent := AValue;
end;

function TRTTI4DMethod.Silent: Boolean;
begin
  Result := FSilent;
end;

procedure TRTTI4DMethod.Update;
begin
  if FRttiMethod = nil then
    Exit;

  FName := FRttiMethod.Name;
  FType := TRTTI4DMethodType.GetMethodType(FRttiMethod.ReturnType);
  FVisibility := TRTTI4DVisibility.GetVisibility(FRttiMethod.Visibility);
end;

function TRTTI4DMethod.VerifyMethod(AParams: TArray<TValue>): Boolean;
begin
  Result := False;

  if not MethodExists(AParams) then
  begin
    if not FSilent then
      raise ERTTIMethodNotExists.Create(FParent.ClassName, FName);
    Exit;
  end;

  if not FParent.IsRefInstance then
  begin
    if not FSilent then
      raise ERTTIObjectIsNotInstance.Create(FParent.ClassName);
    Exit;
  end;

  Result := True;
end;

function TRTTI4DMethod.Visibility: TRTTI4DVisibility;
begin
  Result := FVisibility;
end;

end.
