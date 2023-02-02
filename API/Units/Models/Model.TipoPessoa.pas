unit Model.TipoPessoa;

interface

type TTipoPessoa = class
  FCodigo: integer;
  FDescricao: string;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;

  private

  public
    property id:Integer read FCodigo;
    property descricao: string read FDescricao;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;
end;

implementation

end.
