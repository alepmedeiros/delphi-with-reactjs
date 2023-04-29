program masterfull;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.cors,
  Horse.Jhonson,
  System.SysUtils,
  masterfull.resource.connect in 'src\resource\masterfull.resource.connect.pas',
  masterfull.resource.services in 'src\resource\masterfull.resource.services.pas',
  masterfull.model.entity.usuarios in 'src\model\entity\masterfull.model.entity.usuarios.pas',
  masterfull.controller.usuario in 'src\controller\masterfull.controller.usuario.pas';

procedure IniciarHorse;
var
  lHorse: THorse;
  lPort: Integer;
begin
  lPort := 9000;
  lHorse := THorse.Create;

  lHorse.Use(cors).Use(Jhonson);

  //aqui estra os endpoint resgistrados

  lHorse.Listen(lPort,
  procedure
  begin
    Writeln(Format('Servidor rodando na porta %d', [lHorse.Port]));
    Readln;
  end);
end;

begin
  IniciarHorse;
end.
