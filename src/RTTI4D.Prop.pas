unit RTTI4D.Prop;

interface

uses
  RTTI4D.Intf,
  RTTI4D.Exceptions,
  RTTI4D.Enum,
  System.Rtti,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Variants;

type
  TRTTI4DProperty = class(TInterfacedPersistent, IRTTI4DProperty)
  private
    FSilent: Boolean;
    FParent: IRTTI4DObject;
    FRttiProperty: TRttiProperty;

    FName: string;
    FType: TRTTI4DType;
    FVisibility: TRTTI4DVisibility;
    FIsReadable: Boolean;
    FIsWritable: Boolean;

    procedure Update;
    function VerifyProperty(const AType: TRTTI4DType;
      const AOperation: TRTTI4DOperation): Boolean;
    function PropertyExists: Boolean;
    function PropertyIsType(const AType: TRTTI4DType): Boolean;
    function VerifyType(const AType: TRTTI4DType): Boolean;
    procedure SetValue(const AValue: TValue);
    function GetValue: TValue;

    constructor Create(const ARttiProperty: TRttiProperty;
      AObject: IRTTI4DObject); overload;
    constructor Create(const APropertyName: string;
      AObject: IRTTI4DObject); overload;
  public
    class function New(const ARttiProperty: TRttiProperty;
      AObject: IRTTI4DObject): IRTTI4DProperty; overload;
    class function New(const APropertyName: string;
      AObject: IRTTI4DObject): IRTTI4DProperty; overload;

    function Parent: IRTTI4DObject;

    function Silent: Boolean; overload;
    function Silent(const AValue: Boolean): IRTTI4DProperty; overload;
    function Name: string;
    function PropType: TRTTI4DType;
    function Visibility: TRTTI4DVisibility;

    function AsString: string; overload;
    function AsString(const AValue: string): IRTTI4DProperty; overload;
    function AsInteger: Integer; overload;
    function AsInteger(const AValue: Integer): IRTTI4DProperty; overload;
    function AsInt64: Int64; overload;
    function AsInt64(const AValue: Int64): IRTTI4DProperty; overload;
    function AsBoolean: Boolean; overload;
    function AsBoolean(const AValue: Boolean): IRTTI4DProperty; overload;
    function AsFloat: Double; overload;
    function AsFloat(const AValue: Double): IRTTI4DProperty; overload;
    function AsVariant: Variant; overload;
    function AsVariant(const AValue: Variant): IRTTI4DProperty; overload;
    function Value: TValue; overload;
    function Value(const AValue: TValue): IRTTI4DProperty; overload;
    function AsRTTI: IRTTI4DObject;

    function Attributes: TArray<TCustomAttribute>;
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

implementation

uses
  RTTI4D.Obj;

{ TRTTI4DProperty }

function TRTTI4DProperty.AsString: string;
begin
  Result := '';
  if VerifyProperty(ftString, opRead) then
    Result := GetValue.AsString;
end;

function TRTTI4DProperty.AsBoolean: Boolean;
begin
  Result := False;
  if VerifyProperty(ftEnum, opRead) then
    Result := GetValue.AsBoolean;
end;

function TRTTI4DProperty.AsBoolean(const AValue: Boolean): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftEnum, opWrite) then
    SetValue(TValue.From<Boolean>(AValue));
end;

function TRTTI4DProperty.AsFloat(const AValue: Double): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftFloat, opWrite) then
    SetValue(TValue.From<Extended>(AValue));
end;

function TRTTI4DProperty.AsFloat: Double;
begin
  Result := 0.0;
  if VerifyProperty(ftFloat, opRead) then
    Result := GetValue.AsExtended;
end;

function TRTTI4DProperty.AsInt64: Int64;
begin
  Result := 0;
  if VerifyProperty(ftInteger, opRead) then
    Result := GetValue.AsInt64;
end;

function TRTTI4DProperty.AsInt64(const AValue: Int64): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftInteger, opWrite) then
    SetValue(TValue.From<Int64>(AValue));
end;

function TRTTI4DProperty.AsInteger(const AValue: Integer): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftInteger, opWrite) then
    SetValue(TValue.From<Integer>(AValue));
end;

function TRTTI4DProperty.AsRTTI: IRTTI4DObject;
begin
  Result := nil;
  if VerifyProperty(ftClass, opRead) then
    Result := TRTTI4DObject.New(
      Pointer(PByte(TObject(FParent.RefInstance^)) + (IntPtr(
        TRttiInstanceProperty(FRttiProperty).PropInfo^.GetProc) and
          (not PROPSLOT_MASK))),
      FRttiProperty.PropertyType.AsInstance.MetaclassType, FParent);
end;

function TRTTI4DProperty.AsInteger: Integer;
begin
  Result := 0;
  if VerifyProperty(ftInteger, opRead) then
    Result := GetValue.AsInteger;
end;

function TRTTI4DProperty.AsString(const AValue: string): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftString, opWrite) then
    SetValue(TValue.From<string>(AValue));
end;
function TRTTI4DProperty.AsVariant(const AValue: Variant): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftVariant, opWrite) then
    SetValue(TValue.From<Variant>(AValue));
end;

function TRTTI4DProperty.Attributes: TArray<TCustomAttribute>;
begin
  Result := FRttiProperty.GetAttributes;
end;

function TRTTI4DProperty.AsVariant: Variant;
begin
  Result := Null;
  if VerifyProperty(ftVariant, opRead) then
    Result := GetValue.AsVariant;
end;

constructor TRTTI4DProperty.Create(const APropertyName: string;
  AObject: IRTTI4DObject);
begin
  inherited Create;
  FRttiProperty := nil;
  FParent := AObject;
  FName   := APropertyName;
  FSilent := AObject.Silent;
end;

function TRTTI4DProperty.Parent: IRTTI4DObject;
begin
  Result := FParent;
end;

function TRTTI4DProperty.PropertyExists: Boolean;
begin
  Result := False;

  try
    if (FRttiProperty = nil) then
    begin
      if (not Silent) then
        raise ERTTIPropertyNotExists.Create(FParent.ClassName, FName);
      Exit;
    end;

    Result := True;
  except
    on E: Exception do
      if not FSilent then
        raise;
  end;
end;

function TRTTI4DProperty.PropertyIsType(const AType: TRTTI4DType): Boolean;
begin
  Result := AType = FType;
end;

function TRTTI4DProperty.PropType: TRTTI4DType;
begin
  Result := FType;
end;

function TRTTI4DProperty.GetAttribute(
  const AClass: TCustomAttributeClass): TCustomAttribute;
begin
  Result := FRttiProperty.GetAttribute(AClass);
end;

function TRTTI4DProperty.GetValue: TValue;
begin
  try
    Result := FRttiProperty.GetValue(TObject(FParent.RefInstance^));
  except
    on E: Exception do
      if not FSilent then
        raise;
  end;
end;

function TRTTI4DProperty.HasAttribute(
  const AClass: TCustomAttributeClass): Boolean;
begin
  Result := FRttiProperty.HasAttribute(AClass);
end;

constructor TRTTI4DProperty.Create(const ARttiProperty: TRttiProperty;
  AObject: IRTTI4DObject);
begin
  inherited Create;
  FRttiProperty := ARttiProperty;
  FParent := AObject;
  FSilent := AObject.Silent;

  Update;
end;

function TRTTI4DProperty.Name: string;
begin
  Result := FName;
end;

class function TRTTI4DProperty.New(const APropertyName: string;
  AObject: IRTTI4DObject): IRTTI4DProperty;
begin
  Result := TRTTI4DProperty.Create(APropertyName, AObject);
end;

procedure TRTTI4DProperty.SetValue(const AValue: TValue);
begin
  try
    FRttiProperty.SetValue(TObject(FParent.RefInstance^), AValue);
  except
    on E: Exception do
      if not FSilent then
        raise;
  end;
end;

function TRTTI4DProperty.Silent(const AValue: Boolean): IRTTI4DProperty;
begin
  Result := Self;
  FSilent := AValue;
end;

function TRTTI4DProperty.Silent: Boolean;
begin
  Result := FSilent;
end;

class function TRTTI4DProperty.New(const ARttiProperty: TRttiProperty;
  AObject: IRTTI4DObject): IRTTI4DProperty;
begin
  Result := TRTTI4DProperty.Create(ARttiProperty, AObject);
end;

procedure TRTTI4DProperty.Update;
begin
  if FRttiProperty = nil then
    Exit;

  FName := FRttiProperty.Name;
  FType := TRTTI4DType.GetType(FRttiProperty.PropertyType.TypeKind);
  FVisibility := TRTTI4DVisibility.GetVisibility(FRttiProperty.Visibility);
  FIsReadable := FRttiProperty.IsReadable;
  FIsWritable := FRttiProperty.IsWritable;
end;

function TRTTI4DProperty.Value(const AValue: TValue): IRTTI4DProperty;
begin
  Result := Self;
  if VerifyProperty(ftAny, opWrite) then
    SetValue(AValue);
end;

function TRTTI4DProperty.Value: TValue;
begin
  Result := TValue.Empty;
  if VerifyProperty(ftAny, opWrite) then
    Result := GetValue;
end;

function TRTTI4DProperty.VerifyProperty(const AType: TRTTI4DType;
  const AOperation: TRTTI4DOperation): Boolean;
begin
  Result := False;

  if not PropertyExists then
    Exit;

  if (AOperation = opRead) and (not FIsReadable) then
  begin
    if not FSilent then
      raise ERTTIPropertyIsNotReadable.Create(FParent.ClassName, FName);
    Exit;
  end;

  if (AOperation = opWrite) and (not FIsWritable) then
  begin
    if not FSilent then
      raise ERTTIPropertyIsNotWritable.Create(FParent.ClassName, FName);
    Exit;
  end;

  if (AType <> ftAny) and (not VerifyType(AType)) then
    Exit;

  if not FParent.IsRefInstance then
  begin
    if not FSilent then
      raise ERTTIObjectIsNotInstance.Create(FParent.ClassName);
    Exit;
  end;

  Result := True;
end;

function TRTTI4DProperty.VerifyType(const AType: TRTTI4DType): Boolean;
begin
  Result := True;
  if not PropertyIsType(AType) then
  begin
    Result := False;
    if not FSilent then
      raise ERTTIPropertyTypeError.Create(FParent.ClassName, FName, FType);
  end;
end;

function TRTTI4DProperty.Visibility: TRTTI4DVisibility;
begin
  Result := FVisibility;
end;

end.
