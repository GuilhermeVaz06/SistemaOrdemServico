unit Model.Pessoa;

interface

uses Model.Sessao, Model.TipoDocumento, Model.TipoPessoa, Model.Contato,
     System.SysUtils, Model.Endereco, Model.Connection;

type TPessoa = class
  FCodigo: integer;
  FTipoCadastro: TTipoPessoa;
  FTipoDocumento: TTipoDocumento;
  FDocumento: string;
  FRazaoSocial: string;
  FNomeFantasia: string;
  FTelefone: string;
  FEmail: string;
  FSenha: string;
  FObservacao: string;
  FContatos: TArray<TContato>;
  FEnderecos: TArray<TEndereco>;
  FCadastradoPor: TSessao;
  FAlteradoPor: TSessao;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;
  private

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo;
    property tipoPessoa: TTipoPessoa read FTipoCadastro write FTipoCadastro;
    property tipoDocumento: TTipoDocumento read FTipoDocumento write FTipoDocumento;
    property documento: string read FDocumento write FDocumento;
    property razaoSocial: string read FRazaoSocial write FRazaoSocial;
    property nomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property telefone: string read FTelefone write FTelefone;
    property email: string read FEmail write FEmail;
    property senha: string read FSenha write FSenha;
    property observacao: string read FObservacao write FObservacao;
    property contatos: TArray<TContato> read FContatos write FContatos;
    property enderecos: TArray<TEndereco> read FEnderecos write FEnderecos;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;
end;

var
  FConexecao: TConexao;

implementation

{ TPessoa }

constructor TPessoa.Create;
begin
  FConexecao := TConexao.Create;
end;

destructor TPessoa.Destroy;
begin
  FConexecao.Destroy;
  inherited;
end;

end.
