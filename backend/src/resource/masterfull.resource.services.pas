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
  System.Variants,
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
  DataSet.Serialize,
  GBJSON.Interfaces,
  GBJSON.Helper,
  masterfull.resource.connect;

type
  iService<T: class> = interface
    function Find(const Id: Variant): TJSONObject;
    function FindAll: TJSONArray;
    function FindWhere(Key: String; Value: Variant): TJSONArray;
    function Insert(const Json: TJSONObject): TJSONObject;
    function Update(const Json: TJSONObject): TJSONObject;
    function Delete(Key: String; Value: Variant): iService<T>;
    function DataSet: TDataSet;
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
    function Find(const Id: Variant): TJSONObject;
    function FindAll: TJSONArray;
    function FindWhere(Key: String; Value: Variant): TJSONArray;
    function Insert(const Json: TJSONObject): TJSONObject;
    function Update(const Json: TJSONObject): TJSONObject;
    function Delete(Key: String; Value: Variant): iService<T>;
    function DataSet: TDataSet;
  end;

implementation

constructor TService<T>.Create;
begin
  FIndexConn := masterfull.resource.connect.Connected;
  FDataSource:= TDataSource.Create(nil);
  FConn := TSimpleQueryFiredac.New(masterfull.resource.connect.FConnList.Items[FIndexConn]);
  FDAO := TSimpleDAO<T>.New(FConn).DataSource(FDataSource);
end;

function TService<T>.DataSet: TDataSet;
begin
  Result := FDataSource.DataSet;
end;

function TService<T>.Delete(Key: String; Value: Variant): iService<T>;
begin
  Result := Self;
  FDAO.Delete(Key,Value);
end;

destructor TService<T>.Destroy;
begin
  masterfull.resource.connect.Disconnected(FIndexConn);
  inherited;
end;

function TService<T>.Find(const Id: Variant): TJSONObject;
begin
  FDAO.Find(Integer(Id));
  Result := FDataSource.DataSet.ToJsonObject;
end;

function TService<T>.FindAll: TJSONArray;
begin
  FDAO.Find(False);
  Result := FDataSource.DataSet.toJSonArray;
end;

function TService<T>.FindWhere(Key: String; Value: Variant): TJSONArray;
begin
  FDAO.Find(Key,Value);
  Result := FDataSource.DataSet.ToJsonArray;
end;

function TService<T>.Insert(const Json: TJSONObject): TJSONObject;
var
  lObj: T;
begin
  lObj := T.Create;
  try
    TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
    TGBJSONDefault.Serializer<T>(False).JsonObjectToObject(lObj, Json);
    lObj.fromJSONObject(Json);
    FDAO.Insert(lObj);
    Result := FDataSource.DataSet.ToJSONObject;
  finally
    lObj.Free;
  end;
end;

class function TService<T>.New: TService<T>;
begin
  Result := Self.Create;
end;

function TService<T>.Update(const Json: TJSONObject): TJSONObject;
var
  lObj: T;
begin
  lObj:= T.Create;
  try
    TGBJSONConfig.GetInstance.CaseDefinition(TCaseDefinition.cdLower);
    TGBJSONDefault.Serializer<T>(False).JsonObjectToObject(lObj, Json);
    lObj.fromJSONObject(Json);
    FDAO.Update(lobj);
    Result := FDataSource.DataSet.ToJSONObject;
  finally
    lObj.Free;
  end;
end;

end.
