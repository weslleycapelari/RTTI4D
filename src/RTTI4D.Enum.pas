unit RTTI4D.Enum;

interface

uses
  System.Rtti,
  System.TypInfo;

type
  TRTTI4DType = (ftAny, ftUnknown, ftClass, ftString, ftInteger, ftFloat,
    ftEnum, ftSet, ftArray, ftVariant, ftRecord, ftPointer, ftMethod,
    ftInterface);

  TRTTI4DTypeHelper = record helper for TRTTI4DType
    function ToString: string;
    class function GetType(const AKind: TTypeKind): TRTTI4DType; static;
  end;

  TRTTI4DOperation = (opRead, opWrite);

  TRTTI4DVisibility = (viUnknown, viPublished, viPrivate, viProtected, viPublic);

  TRTTI4DVisibilityHelper = record helper for TRTTI4DVisibility
    function ToString: string;
    class function GetVisibility(
      const AVisibility: TMemberVisibility): TRTTI4DVisibility; static;
  end;

  TRTTI4DMethodType = (mtUnknown, mtProcedure, mtFunction);

  TTRTTI4DMethodTypeHelper = record helper for TRTTI4DMethodType
    function ToString: string;
    class function GetMethodType(
      const AReturnType: TRttiType): TRTTI4DMethodType; static;
  end;

implementation

{ TRTTI4DTypeHelper }

class function TRTTI4DTypeHelper.GetType(
  const AKind: TTypeKind): TRTTI4DType;
begin
  case AKind of
    tkUnknown    : Result := ftUnknown;

    tkInteger,
    tkInt64      : Result := ftInteger;

    tkChar,
    tkWChar      : Result := ftString;

    tkString,
    tkLString,
    tkWString,
    tkUString    : Result := ftString;

    tkFloat      : Result := ftFloat;

    tkEnumeration: Result := ftEnum;

    tkSet        : Result := ftSet;

    tkClass,
    tkClassRef   : Result := ftClass;

    tkMethod,
    tkProcedure  : Result := ftMethod;

    tkVariant    : Result := ftVariant;

    tkArray,
    tkDynArray   : Result := ftArray;

    tkRecord,
    tkMRecord    : Result := ftRecord;

    tkInterface  : Result := ftInterface;

    tkPointer    : Result := ftPointer;
  else
    Result := ftUnknown;
  end;
end;

function TRTTI4DTypeHelper.ToString: string;
begin
  case Self of
    ftUnknown  : Result := 'Unknown';
    ftClass    : Result := 'Class';
    ftString   : Result := 'String';
    ftInteger  : Result := 'Integer';
    ftFloat    : Result := 'Float';
    ftEnum     : Result := 'Enum';
    ftSet      : Result := 'Set';
    ftArray    : Result := 'Array';
    ftVariant  : Result := 'Variant';
    ftRecord   : Result := 'Record';
    ftPointer  : Result := 'Pointer';
    ftMethod   : Result := 'Method';
    ftInterface: Result := 'Interface';
  else
    Result := '';
  end;
end;

{ TRTTI4DVisibilityHelper }

class function TRTTI4DVisibilityHelper.GetVisibility(
  const AVisibility: TMemberVisibility): TRTTI4DVisibility;
begin
  case AVisibility of
    mvPrivate  : Result := viPrivate;
    mvProtected: Result := viProtected;
    mvPublic   : Result := viPublic;
    mvPublished: Result := viPublished;
  else
    Result := viUnknown;
  end;
end;

function TRTTI4DVisibilityHelper.ToString: string;
begin
  case Self of
    viUnknown  : Result := 'Unknown';
    viPublished: Result := 'Published';
    viPrivate  : Result := 'Private';
    viProtected: Result := 'Protected';
    viPublic   : Result := 'Public';
  else
    Result := '';
  end;
end;

{ TTRTTI4DMethodTypeHelper }

class function TTRTTI4DMethodTypeHelper.GetMethodType(
  const AReturnType: TRttiType): TRTTI4DMethodType;
begin
  if AReturnType = nil then
    Exit(mtUnknown);

  case TRTTI4DType.GetType(AReturnType.TypeKind) of
    ftUnknown: Result := mtProcedure;
  else
    Result := mtFunction;
  end;
end;

function TTRTTI4DMethodTypeHelper.ToString: string;
begin
  case Self of
    mtUnknown  : Result := 'Unknown';
    mtProcedure: Result := 'Procedure';
    mtFunction : Result := 'Function';
  else
    Result := '';
  end;
end;

end.
