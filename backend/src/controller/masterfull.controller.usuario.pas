unit masterfull.controller.usuario;

interface

uses
  System.JSON,
  Horse;

procedure Registery(Horse: THorse);

implementation

procedure Cadastrar(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Status;
end;

procedure Login(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Status;
end;

procedure Autorizado(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Status;
end;

procedure BuscarUsuario(Req: THorseRequest; Res: THorseResponse);
begin
  Res.Status;
end;

procedure Registery(Horse: THorse);
begin
  Horse.Post('/usuarios', Login);
  Horse.Post('/usuairos', Cadastrar);
  Horse.Get('/usuarios/autorizado', Autorizado);
  Horse.Get('/usuarios/:id', BuscarUsuario);
end;

end.
