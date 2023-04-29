unit masterfull.resource.services;

interface

uses
  Data.DB,
  System.Generics.Collections,
  SimpleInterface,
  SimpleDAO,
  SimpleAttributes,
  SimpleQueryFiredac,
  System.JSON,
  REST.JSON,
  System.SysUtils,
  System.Classes,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Comp.Client,
  masterfull.resource.connect;

type
  iService<T: class> = interface
    function Find(Id: Integer): T;
    function FindAll: TObjectList<T>;
    function FindWhere(Key: String; Value: Variant): TObjectList<T>;
    function Insert(Value: T): T;
    function Update(Value: T): T;
    function Delete(Value: Variant): iService<T>;
  end;

  TService<T: class, constructor> = class(TInterfacedObject, iService<T>)
  private
    FIndexConn: Integer;
    FConn: iSimpleQuery;
    FDAO: iSimpleDAO<T>;
    FDataSource: TDataSource;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TService<T>;
    function Find(Id: Integer): T;
    function FindAll: TObjectList<T>;
    function FindWhere(Key: String; Value: Variant): TObjectList<T>;
    function Insert(Value: T): T;
    function Update(Value: T): T;
    function Delete(Value: Variant): iService<T>;
  end;

implementation

constructor TService<T>.Create;
begin
  FIndexConn := masterfull.resource.connect.Connected;
  FDataSource:= TDataSource.Create(nil);
  FConn := TSimpleQueryFiredac.New(masterfull.resource.connect.FConnList.Items[FIndexConn]);
  FDAO := TSimpleDAO<T>.New(FConn).DataSource(FDataSource);
end;

function TService<T>.Delete(Value: Variant): iService<T>;
begin
  Result := Self;
  FDAO.Delete('id',Value);
end;

destructor TService<T>.Destroy;
begin
  masterfull.resource.connect.Disconnected(FIndexConn);
  inherited;
end;

function TService<T>.Find(Id: Integer): T;
begin
  Result := FDAO.Find(Id);
end;

function TService<T>.FindAll: TObjectList<T>;
begin
  Result := TObjectList<T>.Create;
  FDAO.Find(Result);
end;

function TService<T>.FindWhere(Key: String; Value: Variant): TObjectList<T>;
begin
  FDAO.Find(Key,Value);
end;

function TService<T>.Insert(Value: T): T;
begin
  FDAO.Insert(Value);
  Result := Value;
end;

class function TService<T>.New: TService<T>;
begin
  Result := Self.Create;
end;

function TService<T>.Update(Value: T): T;
begin
  FDAO.Update(Value);
  Result := Value;
end;

end.
