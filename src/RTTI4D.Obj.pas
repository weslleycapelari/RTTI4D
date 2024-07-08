unit RTTI4D.Obj;

interface

uses
  RTTI4D.Intf,
  RTTI4D.Utils,
  RTTI4D.Exceptions,
  System.Rtti,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Variants,
  System.Generics.Collections;

type
  TRTTI4DObject = class(TInterfacedPersistent, IRTTI4DObject)
  private
    FSilent: Boolean;
    FParent: IRTTI4DObject;
    FRefInstance: Pointer;
    FRefClass: TClass;

    FContext: TRttiContext;
    FType: TRttiType;

    FClassName : string;
    FIsPublic  : Boolean;
    FIsManaged : Boolean;
    FIsInstance: Boolean;
    FIsOrdinal : Boolean;
    FIsRecord  : Boolean;
    FIsSet     : Boolean;
    FIsHFA     : Boolean;

    FPublishedFields: TList<IRTTI4DField>;
    FPrivateFields  : TList<IRTTI4DField>;
    FProtectedFields: TList<IRTTI4DField>;
    FPublicFields   : TList<IRTTI4DField>;

    FPublishedProperties: TList<IRTTI4DProperty>;
    FPrivateProperties  : TList<IRTTI4DProperty>;
    FProtectedProperties: TList<IRTTI4DProperty>;
    FPublicProperties   : TList<IRTTI4DProperty>;

    FPublishedMethods: TList<IRTTI4DMethod>;
    FPrivateMethods  : TList<IRTTI4DMethod>;
    FProtectedMethods: TList<IRTTI4DMethod>;
    FPublicMethods   : TList<IRTTI4DMethod>;

    /// <summary>
    ///  Função interna responsável por atualizar os dados internos
    ///  através dos valores definidos
    /// </summary>
    procedure Update(const AIsClass: Boolean;
      const AIsTypedPointer: Boolean = True);

    /// <summary>
    ///  Construtor interno, apenas para gerar os valores padrões e necessários
    ///  da classe
    /// </summary>
    constructor Create(AObject: IRTTI4DObject);
  public
    destructor Destroy; override;

    class function New(const AClass: TClass): IRTTI4DObject; overload;
    class function New(const AClass: TClass;
      AObject: IRTTI4DObject): IRTTI4DObject; overload;
    class function New<T: class>: IRTTI4DObject; overload;
    class function New<T: class>(
      AObject: IRTTI4DObject): IRTTI4DObject; overload;
    class function New(AInstance: Pointer): IRTTI4DObject; overload;
    class function New(AInstance: Pointer;
      AObject: IRTTI4DObject): IRTTI4DObject; overload;
    class function New(AInstance: Pointer;
      const AClass: TClass): IRTTI4DObject; overload;
    class function New(AInstance: Pointer; const AClass: TClass;
      AObject: IRTTI4DObject): IRTTI4DObject; overload;
    class function New<T: class>(AInstance: T): IRTTI4DObject; overload;
    class function New<T: class>(AInstance: T;
      AObject: IRTTI4DObject): IRTTI4DObject; overload;

    procedure Release;
    function RttiType: TRttiType;

    function RefInstance: Pointer; overload;
    function RefInstance(AInstance: Pointer): IRTTI4DObject; overload;
    function RefClass: TClass; overload;
    function RefClass(const AClass: TClass): IRTTI4DObject; overload;
    function RefTypeInstance(AInstance: Pointer;
      const AClass: TClass): IRTTI4DObject;
    function Silent: Boolean; overload;
    function Silent(const AValue: Boolean): IRTTI4DObject; overload;
    function Parent: IRTTI4DObject;
    function InheritedClass: IRTTI4DObject;

    function ClassName: string;
    function IsRefInstance: Boolean;
    function IsPublic: Boolean;
    function IsManaged: Boolean;
    function IsInstance: Boolean;
    function IsOrdinal: Boolean;
    function IsRecord: Boolean;
    function IsSet: Boolean;
    function IsHFA: Boolean;

    function PublishedFields: TList<IRTTI4DField>;
    function PrivateFields: TList<IRTTI4DField>;
    function ProtectedFields: TList<IRTTI4DField>;
    function PublicFields: TList<IRTTI4DField>;
    function Fields: TList<IRTTI4DField>;
    function FieldByName(const AName: string): IRTTI4DField;

    function PublishedProperties: TList<IRTTI4DProperty>;
    function PrivateProperties: TList<IRTTI4DProperty>;
    function ProtectedProperties: TList<IRTTI4DProperty>;
    function PublicProperties: TList<IRTTI4DProperty>;
    function Properties: TList<IRTTI4DProperty>;
    function PropertyByName(const AName: string): IRTTI4DProperty;

    function PublishedMethods: TList<IRTTI4DMethod>;
    function PrivateMethods: TList<IRTTI4DMethod>;
    function ProtectedMethods: TList<IRTTI4DMethod>;
    function PublicMethods: TList<IRTTI4DMethod>;
    function Methods: TList<IRTTI4DMethod>;
    function MethodByName(const AName: string): IRTTI4DMethod;

    function Attributes: TArray<TCustomAttribute>;
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

implementation

uses
  RTTI4D.Field,
  RTTI4D.Prop,
  RTTI4D.Method;

{ TRTTI4DObject }

function TRTTI4DObject.Attributes: TArray<TCustomAttribute>;
begin
  Result := FType.GetAttributes;
end;

function TRTTI4DObject.ClassName: string;
begin
  Result := FClassName;
end;

constructor TRTTI4DObject.Create(AObject: IRTTI4DObject);
begin
  inherited Create;
  FContext := TRttiContext.Create;
  FContext.KeepContext;
  FType    := nil;
  FSilent  := False;
  FParent  := AObject;

  FPublishedFields := TList<IRTTI4DField>.Create;
  FPrivateFields   := TList<IRTTI4DField>.Create;
  FProtectedFields := TList<IRTTI4DField>.Create;
  FPublicFields    := TList<IRTTI4DField>.Create;

  FPublishedProperties := TList<IRTTI4DProperty>.Create;
  FPrivateProperties   := TList<IRTTI4DProperty>.Create;
  FProtectedProperties := TList<IRTTI4DProperty>.Create;
  FPublicProperties    := TList<IRTTI4DProperty>.Create;

  FPublishedMethods := TList<IRTTI4DMethod>.Create;
  FPrivateMethods   := TList<IRTTI4DMethod>.Create;
  FProtectedMethods := TList<IRTTI4DMethod>.Create;
  FPublicMethods    := TList<IRTTI4DMethod>.Create;
end;

destructor TRTTI4DObject.Destroy;
begin
  FPublishedFields.Free;
  FPrivateFields.Free;
  FProtectedFields.Free;
  FPublicFields.Free;

  FPublishedProperties.Free;
  FPrivateProperties.Free;
  FProtectedProperties.Free;
  FPublicProperties.Free;

  FPublishedMethods.Free;
  FPrivateMethods.Free;
  FProtectedMethods.Free;
  FPublicMethods.Free;
  inherited;
end;

function TRTTI4DObject.FieldByName(const AName: string): IRTTI4DField;
var
  LField: IRTTI4DField;
begin
  Result := TRTTI4DField.New(AName, Self);
  for LField in Fields do
    if LField.Name.ToUpper.Equals(AName.ToUpper) then
      Exit(LField);
end;

function TRTTI4DObject.Fields: TList<IRTTI4DField>;
begin
  Result := TListUtils<IRTTI4DField>.Join(
    [FPublishedFields, FPrivateFields, FProtectedFields, FPublicFields]);
end;

function TRTTI4DObject.GetAttribute(
  const AClass: TCustomAttributeClass): TCustomAttribute;
begin
  Result := FType.GetAttribute(AClass);
end;

function TRTTI4DObject.HasAttribute(
  const AClass: TCustomAttributeClass): Boolean;
begin
  Result := FType.HasAttribute(AClass);
end;

function TRTTI4DObject.InheritedClass: IRTTI4DObject;
begin
  Result := nil;

  if FType.AsInstance.MetaclassType.ClassParent <> nil then
  begin
    if not FSilent then
      raise ERTTIClassHasNoInheritance.Create(
        FType.AsInstance.MetaclassType.ClassName);
    Exit;
  end;

  Result := TRTTI4DObject.New(FType.AsInstance.MetaclassType.ClassParent);
end;

function TRTTI4DObject.IsHFA: Boolean;
begin
  Result := FIsHFA;
end;

function TRTTI4DObject.IsInstance: Boolean;
begin
  Result := FIsInstance;
end;

function TRTTI4DObject.IsManaged: Boolean;
begin
  Result := FIsManaged;
end;

function TRTTI4DObject.IsOrdinal: Boolean;
begin
  Result := FIsOrdinal;
end;

function TRTTI4DObject.IsPublic: Boolean;
begin
  Result := FIsPublic;
end;

function TRTTI4DObject.IsRecord: Boolean;
begin
  Result := FIsRecord;
end;

function TRTTI4DObject.IsRefInstance: Boolean;
begin
  Result := False;
  if FRefInstance <> nil then
    Exit(True);
end;

function TRTTI4DObject.IsSet: Boolean;
begin
  Result := FIsSet;
end;

function TRTTI4DObject.MethodByName(const AName: string): IRTTI4DMethod;
var
  LMethod: IRTTI4DMethod;
begin
  Result := TRTTI4DMethod.New(AName, Self);
  for LMethod in Methods do
    if LMethod.Name.ToUpper.Equals(AName.ToUpper) then
      Exit(LMethod);
end;

function TRTTI4DObject.Methods: TList<IRTTI4DMethod>;
begin
  Result := TListUtils<IRTTI4DMethod>.Join(
    [FPublishedMethods, FPrivateMethods, FProtectedMethods, FPublicMethods]);
end;

class function TRTTI4DObject.New(AInstance: Pointer): IRTTI4DObject;
begin
  Result := TRTTI4DObject.New(AInstance, nil);
end;

class function TRTTI4DObject.New<T>(AInstance: T): IRTTI4DObject;
begin
  Result := TRTTI4DObject.New<T>(AInstance, nil);
end;

function TRTTI4DObject.Parent: IRTTI4DObject;
begin
  Result := FParent;
end;

function TRTTI4DObject.PrivateFields: TList<IRTTI4DField>;
begin
  Result := FPrivateFields;
end;

function TRTTI4DObject.PrivateMethods: TList<IRTTI4DMethod>;
begin
  Result := FPrivateMethods;
end;

function TRTTI4DObject.PrivateProperties: TList<IRTTI4DProperty>;
begin
  Result := FPrivateProperties;
end;

function TRTTI4DObject.Properties: TList<IRTTI4DProperty>;
begin
  Result := TListUtils<IRTTI4DProperty>.Join(
    [FPublishedProperties, FPrivateProperties, FProtectedProperties,
    FPublicProperties]);
end;

function TRTTI4DObject.PropertyByName(const AName: string): IRTTI4DProperty;
var
  LProperty: IRTTI4DProperty;
begin
  Result := TRTTI4DProperty.New(AName, Self);
  for LProperty in Properties do
    if LProperty.Name.ToUpper.Equals(AName.ToUpper) then
      Exit(LProperty);
end;

function TRTTI4DObject.ProtectedFields: TList<IRTTI4DField>;
begin
  Result := FProtectedFields;
end;

function TRTTI4DObject.ProtectedMethods: TList<IRTTI4DMethod>;
begin
  Result := FProtectedMethods;
end;

function TRTTI4DObject.ProtectedProperties: TList<IRTTI4DProperty>;
begin
  Result := FProtectedProperties;
end;

function TRTTI4DObject.PublicFields: TList<IRTTI4DField>;
begin
  Result := FPublicFields;
end;

function TRTTI4DObject.PublicMethods: TList<IRTTI4DMethod>;
begin
  Result := FPublicMethods;
end;

function TRTTI4DObject.PublicProperties: TList<IRTTI4DProperty>;
begin
  Result := FPublicProperties;
end;

function TRTTI4DObject.PublishedFields: TList<IRTTI4DField>;
begin
  Result := FPublishedFields;
end;

function TRTTI4DObject.PublishedMethods: TList<IRTTI4DMethod>;
begin
  Result := FPublishedMethods;
end;

function TRTTI4DObject.PublishedProperties: TList<IRTTI4DProperty>;
begin
  Result := FPublishedProperties;
end;

class function TRTTI4DObject.New<T>: IRTTI4DObject;
begin
  Result := TRTTI4DObject.New<T>(nil);
end;

class function TRTTI4DObject.New(const AClass: TClass): IRTTI4DObject;
begin
  Result := TRTTI4DObject.New(AClass, nil);
end;

function TRTTI4DObject.RefClass(const AClass: TClass): IRTTI4DObject;
begin
  Result := Self;
  if AClass <> FRefClass then
  begin
    FRefClass := AClass;
    Update(True);
  end;
end;

function TRTTI4DObject.RefInstance(AInstance: Pointer): IRTTI4DObject;
begin
  Result := Self;
  if AInstance <> FRefInstance then
  begin
    FRefInstance := AInstance;
    Update(False);
  end;
end;

function TRTTI4DObject.RefTypeInstance(AInstance: Pointer;
  const AClass: TClass): IRTTI4DObject;
begin
  Result := Self;
  if (AInstance <> FRefInstance) or (AClass <> FRefClass) then
  begin
    FRefInstance := AInstance;
    FRefClass := AClass;
    Update(False, False);
  end;
end;

procedure TRTTI4DObject.Release;
begin
  Destroy;
end;

function TRTTI4DObject.RttiType: TRttiType;
begin
  Result := FType;
end;

function TRTTI4DObject.RefInstance: Pointer;
begin
  Result := FRefInstance;
end;

function TRTTI4DObject.Silent(const AValue: Boolean): IRTTI4DObject;
var
  LField   : IRTTI4DField;
  LProperty: IRTTI4DProperty;
begin
  Result  := Self;
  FSilent := AValue;

  for LField in Fields do
    LField.Silent(AValue);

  for LProperty in Properties do
    LProperty.Silent(AValue);
end;

function TRTTI4DObject.Silent: Boolean;
begin
  Result := FSilent;
end;

procedure TRTTI4DObject.Update(const AIsClass, AIsTypedPointer: Boolean);
var
  LField   : TRttiField;
  LProperty: TRttiProperty;
  LMethod  : TRttiMethod;
begin
  if AIsTypedPointer then
  begin
    if AIsClass then
    begin
      FType := FContext.GetType(FRefClass);

      if FRefInstance <> nil then
        if FType <> FContext.GetType(TObject(FRefInstance^).ClassType) then
          FRefInstance := nil;
    end
    else
    begin
      try
        FRefClass := nil;
        FType := FContext.GetType(TObject(FRefInstance^).ClassType);
      except
        FRefInstance := nil;
        if not FSilent then
          raise ERTTIPointerIsSimple.Create;
        Exit;
      end;
    end;
  end
  else
    FType := FContext.GetType(FRefClass);

  FRefClass   := FType.AsInstance.MetaclassType;
  FClassName  := FRefClass.ClassName;
  FIsPublic   := FType.IsPublicType;
  FIsManaged  := FType.IsManaged;
  FIsInstance := FType.IsInstance;
  FIsOrdinal  := FType.IsOrdinal;
  FIsRecord   := FType.IsRecord;
  FIsSet      := FType.IsSet;
  FIsHFA      := FType.IsHFA;

  FPublishedFields.Clear;
  FPrivateFields.Clear;
  FProtectedFields.Clear;
  FPublicFields.Clear;
  for LField in FType.GetFields do
  begin
    case LField.Visibility of
      mvPublished : FPublishedFields.Add(TRTTI4DField.New(LField, Self));
      mvPrivate   : FPrivateFields.Add(TRTTI4DField.New(LField, Self));
      mvProtected : FProtectedFields.Add(TRTTI4DField.New(LField, Self));
      mvPublic    : FPublicFields.Add(TRTTI4DField.New(LField, Self));
    end;
  end;

  FPublishedProperties.Clear;
  FPrivateProperties.Clear;
  FProtectedProperties.Clear;
  FPublicProperties.Clear;
  for LProperty in FType.GetProperties do
  begin
    case LProperty.Visibility of
      mvPublished :
        FPublishedProperties.Add(TRTTI4DProperty.New(LProperty, Self));
      mvPrivate   :
        FPrivateProperties.Add(TRTTI4DProperty.New(LProperty, Self));
      mvProtected :
        FProtectedProperties.Add(TRTTI4DProperty.New(LProperty, Self));
      mvPublic    :
        FPublicProperties.Add(TRTTI4DProperty.New(LProperty, Self));
    end;
  end;

  FPublishedMethods.Clear;
  FPrivateMethods.Clear;
  FProtectedMethods.Clear;
  FPublicMethods.Clear;
  for LMethod in FType.GetMethods do
  begin
    case LMethod.Visibility of
      mvPublished : FPublishedMethods.Add(TRTTI4DMethod.New(LMethod, Self));
      mvPrivate   : FPrivateMethods.Add(TRTTI4DMethod.New(LMethod, Self));
      mvProtected : FProtectedMethods.Add(TRTTI4DMethod.New(LMethod, Self));
      mvPublic    : FPublicMethods.Add(TRTTI4DMethod.New(LMethod, Self));
    end;
  end;
end;

function TRTTI4DObject.RefClass: TClass;
begin
  Result := FRefClass;
end;

class function TRTTI4DObject.New(const AClass: TClass;
  AObject: IRTTI4DObject): IRTTI4DObject;
begin
  Result := TRTTI4DObject.Create(AObject);
  Result.RefClass(AClass);
end;

class function TRTTI4DObject.New(AInstance: Pointer;
  AObject: IRTTI4DObject): IRTTI4DObject;
begin
  Result := TRTTI4DObject.Create(AObject);
  Result.RefInstance(AInstance);
end;

class function TRTTI4DObject.New<T>(AObject: IRTTI4DObject): IRTTI4DObject;
begin
  Result := TRTTI4DObject.Create(AObject);
  Result.RefClass(T);
end;

class function TRTTI4DObject.New<T>(AInstance: T;
  AObject: IRTTI4DObject): IRTTI4DObject;
begin
  Result := TRTTI4DObject.Create(AObject);
  Result.RefInstance(@AInstance);
end;

class function TRTTI4DObject.New(AInstance: Pointer; const AClass: TClass;
  AObject: IRTTI4DObject): IRTTI4DObject;
begin
  Result := TRTTI4DObject.Create(AObject);
  Result.RefTypeInstance(AInstance, AClass);
end;

class function TRTTI4DObject.New(AInstance: Pointer;
  const AClass: TClass): IRTTI4DObject;
begin
  Result := TRTTI4DObject.New(AInstance, AClass, nil);
end;

end.
