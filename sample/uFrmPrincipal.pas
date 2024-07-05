unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Rtti;

type
  TForm1 = class(TForm)
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  {$RTTI EXPLICIT
    METHODS([vcPrivate, vcProtected, vcPublic, vcPublished])
    PROPERTIES([vcPrivate, vcProtected, vcPublic, vcPublished])
    FIELDS([vcPrivate, vcProtected, vcPublic, vcPublished])}
  TSampleClass2 = class
  private
    FFieldOne: Integer;
    FFieldTwo: string;
    FFieldThree: Boolean;

  protected
  public

    constructor Create(AOne: Integer; ATwo: string; AThree: Boolean);

    property FieldOne  : Integer read  FFieldOne;
    property FieldTwo  : string  write FFieldTwo;
    property FieldThree: Boolean read  FFieldThree write FFieldThree;
  end;

  {$RTTI EXPLICIT
    METHODS([vcPrivate, vcProtected, vcPublic, vcPublished])
    PROPERTIES([vcPrivate, vcProtected, vcPublic, vcPublished])
    FIELDS([vcPrivate, vcProtected, vcPublic, vcPublished])}
  TSampleClass = class
  private
    FFieldOne: Integer;
    FFieldTwo: string;
    FFieldThree: Boolean;
    FFieldFour: TSampleClass2;

    function WhatsFieldOne: Integer;
  protected
    function WhatsFieldTwo: string; overload;
  public
    function WhatsFieldThree: Boolean;
    function WhatsFieldTwo(AParam: string;
      AParam2: Boolean = True): string; overload;

    constructor Create(AOne: Integer; ATwo: string; AThree: Boolean);

    property FieldOne  : Integer               read  FFieldOne;
    property FieldTwo  : string                                  write FFieldTwo;
    property FieldThree: Boolean               read  FFieldThree write FFieldThree;
    property FieldFour : TSampleClass2 index 1 read  FFieldFour  write FFieldFour;
  end;

var
  Form1: TForm1;

implementation

uses
  RTTI4D;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
var
  LRTTI  : IRTTI4DObject;
  LSample: TSampleClass;
begin
  LSample := TSampleClass.Create(1, '2', False);
  try
    LRTTI := TRTTI4DObject.New(@LSample);
    //ShowMessage(LRTTI.ClassName);

    {try
      LRTTI.FieldByName('FieldTest').AsString('test');
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    try
      LRTTI.FieldByName('FFieldOne').AsString('test');
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    try
      //ShowMessage(LRTTI.FieldByName('FFieldTwo').AsString);
      LRTTI
        .FieldByName('FFieldTwo').AsString('test').Parent
        .FieldByName('FFieldThree').AsBoolean(True).Parent
        .PropertyByName('FieldTwo').AsString('testProp').Parent;
        //.PropertyByName('FieldOne').AsInteger(7).Parent;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    try
      ShowMessage(LRTTI.MethodByName('WhatsFieldTwo').Call(['testeeeee', True]).Result.AsString);
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;       }

    try
      ShowMessage(LRTTI.PropertyByName('FFieldFour').AsRTTI.FieldByName('FFieldOne').AsInteger.ToString);
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
  finally
    LRTTI.Release;
    FreeAndNil(LSample);
  end;
end;

{ TSampleClass }

constructor TSampleClass.Create(AOne: Integer; ATwo: string; AThree: Boolean);
begin
  inherited Create;
  FFieldOne   := AOne;
  FFieldTwo   := ATwo;
  FFieldThree := AThree;
  FFieldFour  := TSampleClass2.Create(AOne, ATwo, AThree);
end;

function TSampleClass.WhatsFieldOne: Integer;
begin
  Result := FFieldOne;
end;

function TSampleClass.WhatsFieldThree: Boolean;
begin
  Result := FFieldThree;
end;

function TSampleClass.WhatsFieldTwo(AParam: string; AParam2: Boolean): string;
begin
  Result := FFieldTwo;
  if not AParam2 then
    Result := AParam;
end;

function TSampleClass.WhatsFieldTwo: string;
begin
  Result := FFieldTwo;
end;

{ TSampleClass2 }

constructor TSampleClass2.Create(AOne: Integer; ATwo: string; AThree: Boolean);
begin
  inherited Create;
  FFieldOne   := AOne;
  FFieldTwo   := ATwo;
  FFieldThree := AThree;
end;

end.
