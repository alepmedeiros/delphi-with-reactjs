unit masterfull.controller.usuario;

interface

uses
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  Horse,
  JOSE.CORE.JWT,
  JOSE.Core.Builder;

procedure Registery(Horse: THorse);
function Logar(Usuario, Senha: String): TJSONObject;

implementation

uses masterfull.resource.services, masterfull.model.entity.usuarios;

function Logar(Usuario, Senha: String): TJSONObject;
var
  lJWT: TJWT;
  lClaims: TJWTClaims;
  lHora: Integer;
  lJSON: TJSONObject;
begin
  lJWT:= TJWT.Create;
  lClaims := lJWT.Claims;
  lClaims.JSON := TJSONObject.Create;
  lClaims.Expiration := IncHour(Now, 1);
  lHora := Trunc(lClaims.Expiration);
end;

procedure Cadastrar(Req: THorseRequest; Res: THorseResponse);
var
  lBody: TJSONObject;
begin
  try
    lBody := TJSONObject.ParseJSONValue(Req.Body) as TJsonObject;
    lBody := TService<TUsuario>.New.Insert(lBody);
    Res.Status(200).Send<TJSONObject>(lBody);
  except
    Res.Status(500);
  end;
end;

procedure Login(Req: THorseRequest; Res: THorseResponse);
begin

end;

procedure Autorizado(Req: THorseRequest; Res: THorseResponse);
begin

end;

procedure BuscarUsuario(Req: THorseRequest; Res: THorseResponse);
begin

end;

procedure Registery(Horse: THorse);
begin
  Horse.Post('/usuarios', Login);
  Horse.Post('/usuairos', Cadastrar);
  Horse.Get('/usuarios/autorizado', Autorizado);
  Horse.Get('/usuarios/:id', BuscarUsuario);
end;

end.
