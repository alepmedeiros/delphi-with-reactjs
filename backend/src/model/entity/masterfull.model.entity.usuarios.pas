unit masterfull.model.entity.usuarios;

interface

uses
  SimpleAttributes;

type
  [Tabela('USUARIOS')]
  TUsuario = class
  private
    FId: Integer;
    FNome: String;
    FEmail: String;
    FSenha: String;
    FUserName: String;
  public
    [Campo('ID'), PK, AutoInc]
    property Id: Integer read FId write FId;
    [Campo('NOME')]
    property Nome: String read FNome write FNome;
    [Campo('USERNAME')]
    property UserName: String read FUserName write FUserName;
    [Campo('EMAIL')]
    property Email: String read FEmail write FEmail;
    [Campo('SENHA')]
    property Senha: String read FSenha write FSenha;

    class function New: TUsuario;
  end;

implementation

{ TUsuario }

class function TUsuario.New: TUsuario;
begin
  Result := Self.Create;
end;

end.
