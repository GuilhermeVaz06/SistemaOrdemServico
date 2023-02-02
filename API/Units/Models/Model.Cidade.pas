unit Model.Cidade;

interface

uses Model.Sessao, Model.Estado;

type TCidade = class
  FCodigo: integer;
  FEstado: TEstado;
  FCodigoIbge: string;
  FNome: string;
  FCadastradoPor: TSessao;
  FAlteradoPor: TSessao;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;

  private

  public
    property id: Integer read FCodigo;
    property estado: TEstado read FEstado write FEstado;
    property codigoIbge: string read FCodigoIbge write FCodigoIbge;
    property nome: string read FNome write FNome;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;
end;

implementation

end.
