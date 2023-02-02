unit Model.Endereco;

interface

uses Model.Sessao, Model.Cidade, Model.TipoEndereco;

type TEndereco = class
  FCodigo: integer;
  FTipoEndereco: TTipoEndereco;
  FCep: string;
  FLongradouro: string;
  FNumero: string;
  FBairro: string;
  FComplemento: string;
  FObservacao: string;
  FCidade: TCidade;
  FPrioridade: string;
  FCadastradoPor: TSessao;
  FAlteradoPor: TSessao;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;

  private

  public
    property id: Integer read FCodigo;
    property tipoEndereco: TTipoEndereco read FTipoEndereco write FTipoEndereco;
    property cep: string read FCep write FCep;
    property longradouro: string read FLongradouro write FLongradouro;
    property numero: string read FNumero write FNumero;
    property bairro: string read FBairro write FBairro;
    property complemento: string read FComplemento write FComplemento;
    property observacao: string read FObservacao write FObservacao;
    property cidade: TCidade read FCidade write FCidade;
    property prioridade: string read FPrioridade write FPrioridade;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;
end;

implementation

end.
