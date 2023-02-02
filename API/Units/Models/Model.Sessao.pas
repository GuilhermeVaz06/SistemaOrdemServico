unit Model.Sessao;

interface

uses Model.Connection, ZDataset, System.SysUtils;

type TSessao = class

  private
    FCodigo: integer;
    FUsuario: string;
    FDataCadastro: TDateTime;
    FUltimaAlteracao: TDateTime;
    FStatus: string;

  public
    constructor Create;
    destructor Destroy; override;

    property id: Integer read FCodigo write FCodigo;
    property usuario: string read FUsuario write FUsuario;
    property dataCadastro: TDateTime read FDataCadastro write FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao write FUltimaAlteracao;
    property status: string read FStatus write FStatus;

    procedure limpar;
end;

var
  FConexecao: TConexao;

implementation

{ TSessao }

constructor TSessao.Create;
begin
  inherited;
end;

destructor TSessao.Destroy;
begin
  inherited;
end;

procedure TSessao.limpar;
begin
  FCodigo := 0;
  FUsuario := '';
  FDataCadastro := Now;
  FUltimaAlteracao := Now;
  FStatus := 'A';
end;

end.
