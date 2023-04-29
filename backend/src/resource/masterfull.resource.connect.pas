unit masterfull.resource.connect;

interface

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.Intf,
  Firedac.Phys.SQLite,
  Firedac.Phys.SQLiteDef,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Comp.Client,
  Firedac.DApt,
  FireDAC.Comp.UI;

var
  FConnList: TObjectList<TFDConnection>;
  FDriver: TFDPhysSQLiteDriverLink;

function Connected: Integer;
procedure Disconnected(IndexConn: Integer);

implementation

function Connected: Integer;
var
  lIndex: Integer;
  lDataBase: String;
begin
  lDataBase := '..\db\dados.sdb';

  if not Assigned(FConnList) then
    FConnList := TObjectList<TFDConnection>.Create;

  try
    FConnList.Add(TFDConnection.Create(nil));
    FDriver := TFDPhysSQLiteDriverLink.Create(nil);
    lIndex := Pred(FConnList.Count);
    FConnList.Items[lIndex].Params.DriverID := 'SQLite';

    FConnList.Items[lIndex].Params.Database := lDataBase;
    FConnList.Items[lIndex].Params.Add('LockingMode=Normal');
    FConnList.Items[lIndex].Connected;
    Result := lIndex;
  except
    raise Exception.Create('Erro ao tentar conectar ao banco de dados');
  end;
end;

procedure Disconnected(IndexConn: Integer);
begin
  FConnList.Items[IndexConn].Connected := False;
  FConnList.Items[IndexConn].Free;
  FConnList.TrimExcess;
end;

end.
