unit RTTI4D;

interface

uses
  RTTI4D.Enum,
  RTTI4D.Exceptions,
  RTTI4D.Intf,
  RTTI4D.Obj;

type
  { Enumerations }
  TRTTI4DType = RTTI4D.Enum.TRTTI4DType;
  TRTTI4DOperation = RTTI4D.Enum.TRTTI4DOperation;
  TRTTI4DVisibility = RTTI4D.Enum.TRTTI4DVisibility;
  TRTTI4DMethodType = RTTI4D.Enum.TRTTI4DMethodType;

  { Exceptions }
  ERTTIException = RTTI4D.Exceptions.ERTTIException;
  ERTTIPointerIsSimple = RTTI4D.Exceptions.ERTTIPointerIsSimple;
  ERTTIFieldNotExists = RTTI4D.Exceptions.ERTTIFieldNotExists;
  ERTTIFieldTypeError = RTTI4D.Exceptions.ERTTIFieldTypeError;
  ERTTIFieldIsNotReadable = RTTI4D.Exceptions.ERTTIFieldIsNotReadable;
  ERTTIFieldIsNotWritable = RTTI4D.Exceptions.ERTTIFieldIsNotWritable;
  ERTTIPropertyNotExists = RTTI4D.Exceptions.ERTTIPropertyNotExists;
  ERTTIPropertyTypeError = RTTI4D.Exceptions.ERTTIPropertyTypeError;
  ERTTIPropertyIsNotReadable = RTTI4D.Exceptions.ERTTIPropertyIsNotReadable;
  ERTTIPropertyIsNotWritable = RTTI4D.Exceptions.ERTTIPropertyIsNotWritable;
  ERTTIObjectIsNotInstance = RTTI4D.Exceptions.ERTTIObjectIsNotInstance;
  ERTTIMethodNotExists = RTTI4D.Exceptions.ERTTIMethodNotExists;
  ERTTIClassHasNoInheritance = RTTI4D.Exceptions.ERTTIClassHasNoInheritance;

  { Interfaces }
  IRTTI4DObject = RTTI4D.Intf.IRTTI4DObject;
  IRTTI4DField = RTTI4D.Intf.IRTTI4DField;
  IRTTI4DProperty = RTTI4D.Intf.IRTTI4DProperty;
  IRTTI4DMethod = RTTI4D.Intf.IRTTI4DMethod;

  { Classes }
  TRTTI4DObject = RTTI4D.Obj.TRTTI4DObject;

implementation

end.
