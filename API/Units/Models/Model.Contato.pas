unit Model.Contato;

interface

uses Model.Sessao;

type TContato = class
  FCodigo: integer;
  FCpf: string;
  FNome: string;
  FDataNascimento: TDateTime;
  FFuncao: string;
  FTelefone: string;
  FEmail: string;
  FCadastradoPor: TSessao;
  FAlteradoPor: TSessao;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;
  private

  public
    property id:Integer read FCodigo;
    property cpf: string read FCpf write FCpf;
    property nome: string read FNome write FNome;
    property dataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property funcao: string read FFuncao write FFuncao;
    property telefone: string read FTelefone write FTelefone;
    property email: string read FEmail write FEmail;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;
end;

implementation

{ TContato }

end.
