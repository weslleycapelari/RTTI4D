unit RTTI4D.Exceptions;

interface

uses
  RTTI4D.Enum,
  System.SysUtils;

type
  ERTTIException = class(Exception)
    constructor Create; overload;
  end;

  ERTTIPointerIsSimple = class(ERTTIException)
    constructor Create;
  end;

  ERTTIFieldNotExists = class(ERTTIException)
    constructor Create(const AClassName, AFieldName: string);
  end;

  ERTTIFieldTypeError = class(ERTTIException)
    constructor Create(const AClassName, AFieldName: string;
      const AType: TRTTI4DType);
  end;

  ERTTIFieldIsNotReadable = class(ERTTIException)
    constructor Create(const AClassName, AFieldName: string);
  end;

  ERTTIFieldIsNotWritable = class(ERTTIException)
    constructor Create(const AClassName, AFieldName: string);
  end;

  ERTTIPropertyNotExists = class(ERTTIException)
    constructor Create(const AClassName, APropertyName: string);
  end;

  ERTTIPropertyTypeError = class(ERTTIException)
    constructor Create(const AClassName, APropertyName: string;
      const AType: TRTTI4DType);
  end;

  ERTTIPropertyIsNotReadable = class(ERTTIException)
    constructor Create(const AClassName, APropertyName: string);
  end;

  ERTTIPropertyIsNotWritable = class(ERTTIException)
    constructor Create(const AClassName, APropertyName: string);
  end;

  ERTTIObjectIsNotInstance = class(ERTTIException)
    constructor Create(const AClassName: string);
  end;

  ERTTIMethodNotExists = class(ERTTIException)
    constructor Create(const AClassName, AMethodName: string);
  end;


implementation

{ ERTTIException }

constructor ERTTIException.Create;
begin
  inherited Create('An exception occurred in RTTI4D.');
end;

{ ERTTIPointerIsOrdinal }

constructor ERTTIPointerIsSimple.Create;
begin
  inherited Create('The pointer is of a simple type.');
end;

{ ERTTIFieldNotExists }

constructor ERTTIFieldNotExists.Create(const AClassName, AFieldName: string);
begin
  inherited CreateFmt('The field %s.%s in class does not exists.',
    [AClassName, AFieldName]);
end;

{ ERTTIFieldTypeError }

constructor ERTTIFieldTypeError.Create(const AClassName, AFieldName: string;
  const AType: TRTTI4DType);
begin
  inherited CreateFmt('The field %s.%s is from type ''%s''.',
    [AClassName, AFieldName, AType.ToString]);
end;

{ ERTTIFieldIsNotReadable }

constructor ERTTIFieldIsNotReadable.Create(const AClassName,
  AFieldName: string);
begin
  inherited CreateFmt('The field %s.%s is not readable.',
    [AClassName, AFieldName]);
end;

{ ERTTIFieldIsNotWritable }

constructor ERTTIFieldIsNotWritable.Create(const AClassName,
  AFieldName: string);
begin
  inherited CreateFmt('The field %s.%s is not writable.',
    [AClassName, AFieldName]);
end;

{ ERTTIPropertyNotExists }

constructor ERTTIPropertyNotExists.Create(const AClassName,
  APropertyName: string);
begin
  inherited CreateFmt('The property %s.%s in class does not exists.',
    [AClassName, APropertyName]);
end;

{ ERTTIPropertyTypeError }

constructor ERTTIPropertyTypeError.Create(const AClassName,
  APropertyName: string; const AType: TRTTI4DType);
begin
  inherited CreateFmt('The property %s.%s is from type ''%s''.',
    [AClassName, APropertyName, AType.ToString]);
end;

{ ERTTIPropertyIsNotReadable }

constructor ERTTIPropertyIsNotReadable.Create(const AClassName,
  APropertyName: string);
begin
  inherited CreateFmt('The property %s.%s is not readable.',
    [AClassName, APropertyName]);
end;

{ ERTTIPropertyIsNotWritable }

constructor ERTTIPropertyIsNotWritable.Create(const AClassName,
  APropertyName: string);
begin
  inherited CreateFmt('The property %s.%s is not writable.',
    [AClassName, APropertyName]);
end;

{ ERTTIObjectIsNotInstance }

constructor ERTTIObjectIsNotInstance.Create(const AClassName: string);
begin
  inherited CreateFmt('The rtti object %s not contains a instance.',
    [AClassName]);
end;

{ ERTTIMethodNotExists }

constructor ERTTIMethodNotExists.Create(const AClassName, AMethodName: string);
begin
  inherited CreateFmt('The method %s.%s in class does not exists.',
    [AClassName, AMethodName]);
end;

end.
