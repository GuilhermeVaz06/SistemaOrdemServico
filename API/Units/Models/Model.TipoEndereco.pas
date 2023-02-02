unit Model.TipoEndereco;

interface

uses Model.Sessao;

type TTipoEndereco = class
  FCodigo: integer;
  FDescricao: string;
  FCadastradoPor: TSessao;
  FAlteradoPor: TSessao;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;

  private

  public
    property id:Integer read FCodigo;
    property descricao: string read FDescricao write FDescricao;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;
end;

implementation
{ TTipoEndereco }

end.
