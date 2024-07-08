unit RTTI4D.Intf;

interface

uses
  RTTI4D.Enum,
  System.Rtti,
  System.Variants,
  System.Generics.Collections;

type
  IRTTI4DField = interface;
  IRTTI4DProperty = interface;
  IRTTI4DMethod = interface;

  /// <summary>
  /// Interface for manipulating RTTI objects.
  /// </summary>
  IRTTI4DObject = interface
    ['{27213384-C37B-4E6E-A9DA-B9E6661C4F5C}']
    /// <summary>
    /// Releases the current instance.
    /// </summary>
    procedure Release;
    /// <summary>
    /// Returns the RTTI type of the object.
    /// </summary>
    /// <returns>The RTTI type of the object.</returns>
    function RttiType: TRttiType;
    /// <summary>
    /// Gets or sets the silent mode.
    /// </summary>
    /// <returns>The current silent mode.</returns>
    function Silent: Boolean; overload;
    /// <summary>
    /// Sets the silent mode.
    /// </summary>
    /// <param name="AValue">The new silent mode.</param>
    /// <returns>The current object instance.</returns>
    function Silent(const AValue: Boolean): IRTTI4DObject; overload;
    /// <summary>
    /// Returns the parent RTTI object.
    /// </summary>
    /// <returns>The parent RTTI object.</returns>
    function Parent: IRTTI4DObject;
    /// <summary>
    /// Returns the inherited class as RTTI object.
    /// </summary>
    /// <returns>The inherited class as RTTI object.</returns>
    function InheritedClass: IRTTI4DObject;
    /// <summary>
    /// Gets or sets the reference instance.
    /// </summary>
    /// <returns>The reference instance.</returns>
    function RefInstance: Pointer; overload;
    /// <summary>
    /// Sets the reference instance.
    /// </summary>
    /// <param name="AInstance">The reference instance.</param>
    /// <returns>The current object instance.</returns>
    function RefInstance(AInstance: Pointer): IRTTI4DObject; overload;
    /// <summary>
    /// Gets or sets the reference class.
    /// </summary>
    /// <returns>The reference class.</returns>
    function RefClass: TClass; overload;
    /// <summary>
    /// Sets the reference class.
    /// </summary>
    /// <param name="AClass">The reference class.</param>
    /// <returns>The current object instance.</returns>
    function RefClass(const AClass: TClass): IRTTI4DObject; overload;
    /// <summary>
    /// Sets the reference type instance.
    /// </summary>
    /// <param name="AInstance">The reference instance.</param>
    /// <param name="AClass">The reference class.</param>
    /// <returns>The current object instance.</returns>
    function RefTypeInstance(AInstance: Pointer;
      const AClass: TClass): IRTTI4DObject;
    /// <summary>
    /// Returns the class name.
    /// </summary>
    /// <returns>The class name.</returns>
    function ClassName: string;
    /// <summary>
    /// Indicates whether the instance is a reference.
    /// </summary>
    /// <returns>True if the instance is a reference, false otherwise.</returns>
    function IsRefInstance: Boolean;
    /// <summary>
    /// Indicates whether the class is public.
    /// </summary>
    /// <returns>True if the class is public, false otherwise.</returns>
    function IsPublic: Boolean;
    /// <summary>
    /// Indicates whether the class is managed.
    /// </summary>
    /// <returns>True if the class is managed, false otherwise.</returns>
    function IsManaged: Boolean;
    /// <summary>
    /// Indicates whether the object is an instance.
    /// </summary>
    /// <returns>True if the object is an instance, false otherwise.</returns>
    function IsInstance: Boolean;
    /// <summary>
    /// Indicates whether the class is ordinal.
    /// </summary>
    /// <returns>True if the class is ordinal, false otherwise.</returns>
    function IsOrdinal: Boolean;
    /// <summary>
    /// Indicates whether the class is a record.
    /// </summary>
    /// <returns>True if the class is a record, false otherwise.</returns>
    function IsRecord: Boolean;
    /// <summary>
    /// Indicates whether the class is a set.
    /// </summary>
    /// <returns>True if the class is a set, false otherwise.</returns>
    function IsSet: Boolean;
    /// <summary>
    /// Indicates whether the class is an HFA
    /// (Homogeneous Floating-point Aggregate).
    /// </summary>
    /// <returns>True if the class is an HFA, false otherwise.</returns>
    function IsHFA: Boolean;
    /// <summary>
    /// Returns a list of published fields.
    /// </summary>
    /// <returns>A list of published fields.</returns>
    function PublishedFields: TList<IRTTI4DField>;
    /// <summary>
    /// Returns a list of private fields.
    /// </summary>
    /// <returns>A list of private fields.</returns>
    function PrivateFields: TList<IRTTI4DField>;
    /// <summary>
    /// Returns a list of protected fields.
    /// </summary>
    /// <returns>A list of protected fields.</returns>
    function ProtectedFields: TList<IRTTI4DField>;
    /// <summary>
    /// Returns a list of public fields.
    /// </summary>
    /// <returns>A list of public fields.</returns>
    function PublicFields: TList<IRTTI4DField>;
    /// <summary>
    /// Returns a list of all fields.
    /// </summary>
    /// <returns>A list of all fields.</returns>
    function Fields: TList<IRTTI4DField>;
    /// <summary>
    /// Returns a field by its name.
    /// </summary>
    /// <param name="AName">The name of the field.</param>
    /// <returns>The field with the specified name.</returns>
    function FieldByName(const AName: string): IRTTI4DField;
    /// <summary>
    /// Returns a list of published properties.
    /// </summary>
    /// <returns>A list of published properties.</returns>
    function PublishedProperties: TList<IRTTI4DProperty>;
    /// <summary>
    /// Returns a list of private properties.
    /// </summary>
    /// <returns>A list of private properties.</returns>
    function PrivateProperties: TList<IRTTI4DProperty>;
    /// <summary>
    /// Returns a list of protected properties.
    /// </summary>
    /// <returns>A list of protected properties.</returns>
    function ProtectedProperties: TList<IRTTI4DProperty>;
    /// <summary>
    /// Returns a list of public properties.
    /// </summary>
    /// <returns>A list of public properties.</returns>
    function PublicProperties: TList<IRTTI4DProperty>;
    /// <summary>
    /// Returns a list of all properties.
    /// </summary>
    /// <returns>A list of all properties.</returns>
    function Properties: TList<IRTTI4DProperty>;
    /// <summary>
    /// Returns a property by its name.
    /// </summary>
    /// <param name="AName">The name of the property.</param>
    /// <returns>The property with the specified name.</returns>
    function PropertyByName(const AName: string): IRTTI4DProperty;
    /// <summary>
    /// Returns a list of published methods.
    /// </summary>
    /// <returns>A list of published methods.</returns>
    function PublishedMethods: TList<IRTTI4DMethod>;
    /// <summary>
    /// Returns a list of private methods.
    /// </summary>
    /// <returns>A list of private methods.</returns>
    function PrivateMethods: TList<IRTTI4DMethod>;
    /// <summary>
    /// Returns a list of protected methods.
    /// </summary>
    /// <returns>A list of protected methods.</returns>
    function ProtectedMethods: TList<IRTTI4DMethod>;
    /// <summary>
    /// Returns a list of public methods.
    /// </summary>
    /// <returns>A list of public methods.</returns>
    function PublicMethods: TList<IRTTI4DMethod>;
    /// <summary>
    /// Returns a list of all methods.
    /// </summary>
    /// <returns>A list of all methods.</returns>
    function Methods: TList<IRTTI4DMethod>;
    /// <summary>
    /// Returns a method by its name.
    /// </summary>
    /// <param name="AName">The name of the method.</param>
    /// <returns>The method with the specified name.</returns>
    function MethodByName(const AName: string): IRTTI4DMethod;
    /// <summary>
    /// Returns a list of custom attributes.
    /// </summary>
    /// <returns>An array of custom attributes.</returns>
    function Attributes: TArray<TCustomAttribute>;
    /// <summary>
    /// Checks if the class of object has a specified attribute.
    /// </summary>
    /// <param name="AClass">The class of the attribute.</param>
    /// <returns>
    /// True if the class of object has the specified attribute,
    /// false otherwise.
    /// </returns>
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    /// <summary>
    /// Returns a list of custom attributes by their class of object.
    /// </summary>
    /// <param name="AClass">The class of the attributes.</param>
    /// <returns>
    /// An array of custom attributes of the specified class of object.
    /// </returns>
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

  /// <summary>
  /// Interface for manipulating RTTI fields.
  /// </summary>
  IRTTI4DField = interface
    ['{D83B1020-B313-41DC-8149-595E4FAC9F95}']
    /// <summary>
    /// Gets or sets the silent mode.
    /// </summary>
    /// <returns>The current silent mode.</returns>
    function Silent: Boolean; overload;
    /// <summary>
    /// Sets the silent mode.
    /// </summary>
    /// <param name="AValue">The new silent mode.</param>
    /// <returns>The current object instance.</returns>
    function Silent(const AValue: Boolean): IRTTI4DField; overload;
    /// <summary>
    /// Returns the parent RTTI object.
    /// </summary>
    /// <returns>The parent RTTI object.</returns>
    function Parent: IRTTI4DObject;
    /// <summary>
    /// Returns the field name.
    /// </summary>
    /// <returns>The field name.</returns>
    function Name: string;
    /// <summary>
    /// Returns the field type.
    /// </summary>
    /// <returns>The field type.</returns>
    function FieldType: TRTTI4DType;
    /// <summary>
    /// Returns the field visibility.
    /// </summary>
    /// <returns>The field visibility.</returns>
    function Visibility: TRTTI4DVisibility;
    /// <summary>
    /// Gets or sets the field value as a string.
    /// </summary>
    /// <returns>The field value as a string.</returns>
    function AsString: string; overload;
    /// <summary>
    /// Sets the field value as a string.
    /// </summary>
    /// <param name="AValue">The field value as a string.</param>
    /// <returns>The current field instance.</returns>
    function AsString(const AValue: string): IRTTI4DField; overload;
    /// <summary>
    /// Gets or sets the field value as an integer.
    /// </summary>
    /// <returns>The field value as an integer.</returns>
    function AsInteger: Integer; overload;
    /// <summary>
    /// Sets the field value as an integer.
    /// </summary>
    /// <param name="AValue">The field value as an integer.</param>
    /// <returns>The current field instance.</returns>
    function AsInteger(const AValue: Integer): IRTTI4DField; overload;
    /// <summary>
    /// Gets or sets the field value as an int64.
    /// </summary>
    /// <returns>The field value as an int64.</returns>
    function AsInt64: Int64; overload;
    /// <summary>
    /// Sets the field value as an int64.
    /// </summary>
    /// <param name="AValue">The field value as an int64.</param>
    /// <returns>The current field instance.</returns>
    function AsInt64(const AValue: Int64): IRTTI4DField; overload;
    /// <summary>
    /// Gets or sets the field value as a boolean.
    /// </summary>
    /// <returns>The field value as a boolean.</returns>
    function AsBoolean: Boolean; overload;
    /// <summary>
    /// Sets the field value as a boolean.
    /// </summary>
    /// <param name="AValue">The field value as a boolean.</param>
    /// <returns>The current field instance.</returns>
    function AsBoolean(const AValue: Boolean): IRTTI4DField; overload;
    /// <summary>
    /// Gets or sets the field value as a float.
    /// </summary>
    /// <returns>The field value as a float.</returns>
    function AsFloat: Double; overload;
    /// <summary>
    /// Sets the field value as a float.
    /// </summary>
    /// <param name="AValue">The field value as a float.</param>
    /// <returns>The current field instance.</returns>
    function AsFloat(const AValue: Double): IRTTI4DField; overload;
    /// <summary>
    /// Gets or sets the field value as a variant.
    /// </summary>
    /// <returns>The field value as a variant.</returns>
    function AsVariant: Variant; overload;
    /// <summary>
    /// Sets the field value as a variant.
    /// </summary>
    /// <param name="AValue">The field value as a variant.</param>
    /// <returns>The current field instance.</returns>
    function AsVariant(const AValue: Variant): IRTTI4DField; overload;
    /// <summary>
    /// Gets or sets the field value as a TValue.
    /// </summary>
    /// <returns>The field value as a TValue.</returns>
    function Value: TValue; overload;
    /// <summary>
    /// Sets the field value as a TValue.
    /// </summary>
    /// <param name="AValue">The field value as a TValue.</param>
    /// <returns>The current field instance.</returns>
    function Value(const AValue: TValue): IRTTI4DField; overload;
    /// <summary>
    /// Gets the field value as a IRTTI4DObject.
    /// </summary>
    /// <returns>The field value as a IRTTI4DObject.</returns>
    function AsRTTI: IRTTI4DObject;
    /// <summary>
    /// Returns a list of custom attributes.
    /// </summary>
    /// <returns>An array of custom attributes.</returns>
    function Attributes: TArray<TCustomAttribute>;
    /// <summary>
    /// Checks if the field of class has a specified attribute.
    /// </summary>
    /// <param name="AClass">The class of the attribute.</param>
    /// <returns>
    /// True if the field of class has the specified attribute, false otherwise.
    /// </returns>
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    /// <summary>
    /// Returns a list of custom attributes by their field of class.
    /// </summary>
    /// <param name="AClass">The class of the attributes.</param>
    /// <returns>
    /// An array of custom attributes of the specified field of class.
    /// </returns>
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

  /// <summary>
  /// Interface for manipulating RTTI properties.
  /// </summary>
  IRTTI4DProperty = interface
    ['{D83B1020-B313-41DC-8149-595E4FAC9F95}']
    /// <summary>
    /// Gets or sets the silent mode.
    /// </summary>
    /// <returns>The current silent mode.</returns>
    function Silent: Boolean; overload;
    /// <summary>
    /// Sets the silent mode.
    /// </summary>
    /// <param name="AValue">The new silent mode.</param>
    /// <returns>The current object instance.</returns>
    function Silent(const AValue: Boolean): IRTTI4DProperty; overload;
    /// <summary>
    /// Returns the parent RTTI object.
    /// </summary>
    /// <returns>The parent RTTI object.</returns>
    function Parent: IRTTI4DObject;
    /// <summary>
    /// Returns the property name.
    /// </summary>
    /// <returns>The property name.</returns>
    function Name: string;
    /// <summary>
    /// Returns the property type.
    /// </summary>
    /// <returns>The property type.</returns>
    function PropType: TRTTI4DType;
    /// <summary>
    /// Returns the property visibility.
    /// </summary>
    /// <returns>The property visibility.</returns>
    function Visibility: TRTTI4DVisibility;
    /// <summary>
    /// Gets or sets the property value as a string.
    /// </summary>
    /// <returns>The property value as a string.</returns>
    function AsString: string; overload;
    /// <summary>
    /// Sets the property value as a string.
    /// </summary>
    /// <param name="AValue">The property value as a string.</param>
    /// <returns>The current property instance.</returns>
    function AsString(const AValue: string): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets or sets the property value as an integer.
    /// </summary>
    /// <returns>The property value as an integer.</returns>
    function AsInteger: Integer; overload;
    /// <summary>
    /// Sets the property value as an integer.
    /// </summary>
    /// <param name="AValue">The property value as an integer.</param>
    /// <returns>The current property instance.</returns>
    function AsInteger(const AValue: Integer): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets or sets the property value as an int64.
    /// </summary>
    /// <returns>The property value as an int64.</returns>
    function AsInt64: Int64; overload;
    /// <summary>
    /// Sets the property value as an int64.
    /// </summary>
    /// <param name="AValue">The property value as an int64.</param>
    /// <returns>The current property instance.</returns>
    function AsInt64(const AValue: Int64): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets or sets the property value as a boolean.
    /// </summary>
    /// <returns>The property value as a boolean.</returns>
    function AsBoolean: Boolean; overload;
    /// <summary>
    /// Sets the property value as a boolean.
    /// </summary>
    /// <param name="AValue">The property value as a boolean.</param>
    /// <returns>The current property instance.</returns>
    function AsBoolean(const AValue: Boolean): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets or sets the property value as a float.
    /// </summary>
    /// <returns>The property value as a float.</returns>
    function AsFloat: Double; overload;
    /// <summary>
    /// Sets the property value as a float.
    /// </summary>
    /// <param name="AValue">The property value as a float.</param>
    /// <returns>The current property instance.</returns>
    function AsFloat(const AValue: Double): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets or sets the property value as a variant.
    /// </summary>
    /// <returns>The property value as a variant.</returns>
    function AsVariant: Variant; overload;
    /// <summary>
    /// Sets the property value as a variant.
    /// </summary>
    /// <param name="AValue">The property value as a variant.</param>
    /// <returns>The current property instance.</returns>
    function AsVariant(const AValue: Variant): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets or sets the property value as a TValue.
    /// </summary>
    /// <returns>The property value as a TValue.</returns>
    function Value: TValue; overload;
    /// <summary>
    /// Sets the property value as a TValue.
    /// </summary>
    /// <param name="AValue">The property value as a TValue.</param>
    /// <returns>The current property instance.</returns>
    function Value(const AValue: TValue): IRTTI4DProperty; overload;
    /// <summary>
    /// Gets the property value as a IRTTI4DObject.
    /// </summary>
    /// <returns>The property value as a IRTTI4DObject.</returns>
    function AsRTTI: IRTTI4DObject;
    /// <summary>
    /// Returns a list of custom attributes.
    /// </summary>
    /// <returns>An array of custom attributes.</returns>
    function Attributes: TArray<TCustomAttribute>;
    /// <summary>
    /// Checks if the property of class has a specified attribute.
    /// </summary>
    /// <param name="AClass">The class of the attribute.</param>
    /// <returns>
    /// True if the property of class has the specified attribute,
    /// false otherwise.
    /// </returns>
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    /// <summary>
    /// Returns a list of custom attributes by their property of class.
    /// </summary>
    /// <param name="AClass">The class of the attributes.</param>
    /// <returns>
    /// An array of custom attributes of the specified property of class.
    /// </returns>
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

  /// <summary>
  /// Interface for manipulating RTTI methods.
  /// </summary>
  IRTTI4DMethod = interface
    ['{D83B1020-B313-41DC-8149-595E4FAC9F95}']
    /// <summary>
    /// Gets or sets the silent mode.
    /// </summary>
    /// <returns>The current silent mode.</returns>
    function Silent: Boolean; overload;
    /// <summary>
    /// Sets the silent mode.
    /// </summary>
    /// <param name="AValue">The new silent mode.</param>
    /// <returns>The current object instance.</returns>
    function Silent(const AValue: Boolean): IRTTI4DMethod; overload;
    /// <summary>
    /// Returns the parent RTTI object.
    /// </summary>
    /// <returns>The parent RTTI object.</returns>
    function Parent: IRTTI4DObject;
    /// <summary>
    /// Returns the method name.
    /// </summary>
    /// <returns>The method name.</returns>
    function Name: string;
    /// <summary>
    /// Returns the method type.
    /// </summary>
    /// <returns>The method type.</returns>
    function MethodType: TRTTI4DMethodType;
    /// <summary>
    /// Returns the method visibility.
    /// </summary>
    /// <returns>The method visibility.</returns>
    function Visibility: TRTTI4DVisibility;
    /// <summary>
    /// Returns the method result.
    /// </summary>
    /// <returns>The method result.</returns>
    function Result: TValue;
    /// <summary>
    /// Indicates whether the method is executed.
    /// </summary>
    /// <returns>True if the method is executed, false otherwise.</returns>
    function Executed: Boolean;
    /// <summary>
    /// Execute method of instance without params.
    /// </summary>
    /// <returns>The current object instance.</returns>
    function Call: IRTTI4DMethod; overload;
    /// <summary>
    /// Execute method of instance with params.
    /// </summary>
    /// <param name="AParams">The array of params.</param>
    /// <returns>The current object instance.</returns>
    function Call(AParams: TArray<Variant>): IRTTI4DMethod; overload;
    /// <summary>
    /// Returns a list of custom attributes.
    /// </summary>
    /// <returns>An array of custom attributes.</returns>
    function Attributes: TArray<TCustomAttribute>;
    /// <summary>
    /// Checks if the method of class has a specified attribute.
    /// </summary>
    /// <param name="AClass">The class of the attribute.</param>
    /// <returns>
    /// True if the method of class has the specified attribute,
    /// false otherwise.
    /// </returns>
    function HasAttribute(const AClass: TCustomAttributeClass): Boolean;
    /// <summary>
    /// Returns a list of custom attributes by their method of class.
    /// </summary>
    /// <param name="AClass">The class of the attributes.</param>
    /// <returns>
    /// An array of custom attributes of the specified method of class.
    /// </returns>
    function GetAttribute(
      const AClass: TCustomAttributeClass): TCustomAttribute;
  end;

implementation

end.
