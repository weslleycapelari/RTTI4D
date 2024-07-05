unit RTTI4D.Field;

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
  TRTTI4DField = class(TInterfacedPersistent, IRTTI4DField)
  private
    FSilent: Boolean;
    FParent: IRTTI4DObject;
    FRttiField: TRttiField;

    FName: string;
    FType: TRTTI4DType;
    FVisibility: TRTTI4DVisibility;
    FIsReadable: Boolean;
    FIsWritable: Boolean;

    procedure Update;
    function VerifyField(const AType: TRTTI4DType;
      const AOperation: TRTTI4DOperation): Boolean;
    function FieldExists: Boolean;
    function FieldIsType(const AType: TRTTI4DType): Boolean;
    function VerifyType(const AType: TRTTI4DType): Boolean;
    procedure SetValue(const AValue: TValue);
    function GetValue: TValue;

    constructor Create(const ARttiField: TRttiField;
      AObject: IRTTI4DObject); overload;
    constructor Create(const AFieldName: string;
      AObject: IRTTI4DObject); overload;
  public
    class function New(const ARttiField: TRttiField;
      AObject: IRTTI4DObject): IRTTI4DField; overload;
    class function New(const AFieldName: string;
      AObject: IRTTI4DObject): IRTTI4DField; overload;

    function Parent: IRTTI4DObject;

    function Silent: Boolean; overload;
    function Silent(const AValue: Boolean): IRTTI4DField; overload;
    function Name: string;
    function FieldType: TRTTI4DType;
    function Visibility: TRTTI4DVisibility;

    function AsString: string; overload;
    function AsString(const AValue: string): IRTTI4DField; overload;
    function AsInteger: Integer; overload;
    function AsInteger(const AValue: Integer): IRTTI4DField; overload;
    function AsInt64: Int64; overload;
    function AsInt64(const AValue: Int64): IRTTI4DField; overload;
    function AsBoolean: Boolean; overload;
    function AsBoolean(const AValue: Boolean): IRTTI4DField; overload;
    function AsFloat: Double; overload;
    function AsFloat(const AValue: Double): IRTTI4DField; overload;
    function AsVariant: Variant; overload;
    function AsVariant(const AValue: Variant): IRTTI4DField; overload;
    function Value: TValue; overload;
    function Value(const AValue: TValue): IRTTI4DField; overload;
    function AsRTTI: IRTTI4DObject;

    function Attributes: TArray<TCustomAttribute>;
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

implementation

uses
  RTTI4D.Obj;

{ TRTTI4DField }

function TRTTI4DField.AsString: string;
begin
  Result := '';
  if VerifyField(ftString, opRead) then
    Result := GetValue.AsString;
end;

function TRTTI4DField.AsBoolean: Boolean;
begin
  Result := False;
  if VerifyField(ftEnum, opRead) then
    Result := GetValue.AsBoolean;
end;

function TRTTI4DField.AsBoolean(const AValue: Boolean): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftEnum, opWrite) then
    SetValue(TValue.From<Boolean>(AValue));
end;

function TRTTI4DField.AsFloat(const AValue: Double): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftFloat, opWrite) then
    SetValue(TValue.From<Extended>(AValue));
end;

function TRTTI4DField.AsFloat: Double;
begin
  Result := 0.0;
  if VerifyField(ftFloat, opRead) then
    Result := GetValue.AsExtended;
end;

function TRTTI4DField.AsInt64: Int64;
begin
  Result := 0;
  if VerifyField(ftInteger, opRead) then
    Result := GetValue.AsInt64;
end;

function TRTTI4DField.AsInt64(const AValue: Int64): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftInteger, opWrite) then
    SetValue(TValue.From<Int64>(AValue));
end;

function TRTTI4DField.AsInteger(const AValue: Integer): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftInteger, opWrite) then
    SetValue(TValue.From<Integer>(AValue));
end;

function TRTTI4DField.AsRTTI: IRTTI4DObject;
begin
  Result := nil;
  if VerifyField(ftClass, opRead) then
    Result := TRTTI4DObject.New(
      Pointer(PByte(TObject(FParent.RefInstance^)) + FRttiField.Offset),
      FRttiField.FieldType.AsInstance.MetaclassType, FParent);
end;

function TRTTI4DField.AsInteger: Integer;
begin
  Result := 0;
  if VerifyField(ftInteger, opRead) then
    Result := GetValue.AsInteger;
end;

function TRTTI4DField.AsString(const AValue: string): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftString, opWrite) then
    SetValue(TValue.From<string>(AValue));
end;
function TRTTI4DField.AsVariant(const AValue: Variant): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftVariant, opWrite) then
    SetValue(TValue.From<Variant>(AValue));
end;

function TRTTI4DField.Attributes: TArray<TCustomAttribute>;
begin
  Result := FRttiField.GetAttributes;
end;

function TRTTI4DField.AsVariant: Variant;
begin
  Result := Null;
  if VerifyField(ftVariant, opRead) then
    Result := GetValue.AsVariant;
end;

constructor TRTTI4DField.Create(const AFieldName: string;
  AObject: IRTTI4DObject);
begin
  inherited Create;
  FRttiField := nil;
  FParent := AObject;
  FName   := AFieldName;
  FSilent := AObject.Silent;
end;

function TRTTI4DField.Parent: IRTTI4DObject;
begin
  Result := FParent;
end;

function TRTTI4DField.FieldExists: Boolean;
begin
  Result := False;

  try
    if (FRttiField = nil) then
    begin
      if (not Silent) then
        raise ERTTIFieldNotExists.Create(FParent.ClassName, FName);
      Exit;
    end;

    Result := True;
  except
    on E: Exception do
      if not FSilent then
        raise;
  end;
end;

function TRTTI4DField.FieldIsType(const AType: TRTTI4DType): Boolean;
begin
  Result := AType = FType;
end;

function TRTTI4DField.FieldType: TRTTI4DType;
begin
  Result := FType;
end;

function TRTTI4DField.GetAttribute(
  const AClass: TCustomAttributeClass): TCustomAttribute;
begin
  Result := FRttiField.GetAttribute(AClass);
end;

function TRTTI4DField.GetValue: TValue;
begin
  try
    Result := FRttiField.GetValue(TObject(FParent.RefInstance^));
  except
    on E: Exception do
      if not FSilent then
        raise;
  end;
end;

function TRTTI4DField.HasAttribute(
  const AClass: TCustomAttributeClass): Boolean;
begin
  Result := FRttiField.HasAttribute(AClass);
end;

constructor TRTTI4DField.Create(const ARttiField: TRttiField;
  AObject: IRTTI4DObject);
begin
  inherited Create;
  FRttiField := ARttiField;
  FParent := AObject;
  FSilent := AObject.Silent;

  Update;
end;

function TRTTI4DField.Name: string;
begin
  Result := FName;
end;

class function TRTTI4DField.New(const AFieldName: string;
  AObject: IRTTI4DObject): IRTTI4DField;
begin
  Result := TRTTI4DField.Create(AFieldName, AObject);
end;

procedure TRTTI4DField.SetValue(const AValue: TValue);
begin
  try
    FRttiField.SetValue(TObject(FParent.RefInstance^), AValue);
  except
    on E: Exception do
      if not FSilent then
        raise;
  end;
end;

function TRTTI4DField.Silent(const AValue: Boolean): IRTTI4DField;
begin
  Result := Self;
  FSilent := AValue;
end;

function TRTTI4DField.Silent: Boolean;
begin
  Result := FSilent;
end;

class function TRTTI4DField.New(const ARttiField: TRttiField;
  AObject: IRTTI4DObject): IRTTI4DField;
begin
  Result := TRTTI4DField.Create(ARttiField, AObject);
end;

procedure TRTTI4DField.Update;
begin
  if FRttiField = nil then
    Exit;

  FName := FRttiField.Name;
  FType := TRTTI4DType.GetType(FRttiField.FieldType.TypeKind);
  FVisibility := TRTTI4DVisibility.GetVisibility(FRttiField.Visibility);
  FIsReadable := FRttiField.IsReadable;
  FIsWritable := FRttiField.IsWritable;
end;

function TRTTI4DField.Value(const AValue: TValue): IRTTI4DField;
begin
  Result := Self;
  if VerifyField(ftAny, opWrite) then
    SetValue(AValue);
end;

function TRTTI4DField.Value: TValue;
begin
  Result := TValue.Empty;
  if VerifyField(ftAny, opWrite) then
    Result := GetValue;
end;

function TRTTI4DField.VerifyField(const AType: TRTTI4DType;
  const AOperation: TRTTI4DOperation): Boolean;
begin
  Result := False;

  if not FieldExists then
    Exit;

  if (AOperation = opRead) and (not FIsReadable) then
  begin
    if not FSilent then
      raise ERTTIFieldIsNotReadable.Create(FParent.ClassName, FName);
    Exit;
  end;

  if (AOperation = opWrite) and (not FIsWritable) then
  begin
    if not FSilent then
      raise ERTTIFieldIsNotWritable.Create(FParent.ClassName, FName);
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

function TRTTI4DField.VerifyType(const AType: TRTTI4DType): Boolean;
begin
  Result := True;
  if not FieldIsType(AType) then
  begin
    Result := False;
    if not FSilent then
      raise ERTTIFieldTypeError.Create(FParent.ClassName, FName, FType);
  end;
end;

function TRTTI4DField.Visibility: TRTTI4DVisibility;
begin
  Result := FVisibility;
end;

end.
