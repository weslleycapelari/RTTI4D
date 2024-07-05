unit RTTI4D.Utils;

interface

uses
  System.Generics.Collections;

type
  TListUtils<T> = class
    class function Join(ALists: TArray<TList<T>>): TList<T>;
  end;

implementation

{ TListUtils<T> }

class function TListUtils<T>.Join(ALists: TArray<TList<T>>): TList<T>;
var
  LList : Integer;
  LCount: Integer;
begin
  Result := TList<T>.Create;
  for LList := 0 to Length(ALists) - 1 do
    for LCount := 0 to Length(ALists[LList].ToArray) - 1 do
      Result.Add(ALists[LList].ToArray[LCount]);
end;

end.
