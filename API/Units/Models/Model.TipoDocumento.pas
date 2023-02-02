unit Model.TipoDocumento;

interface

uses system.SysUtils, Model.Sessao;

type
  TTipoDocumento = class
  FCodigo: integer;
  FDescricao: string;
  FQtdeCaracteres: integer;
  FMascara: string;
  FCadastradoPor: TSessao;
  FAlteradoPor: TSessao;
  FDataCadastro: TDateTime;
  FUltimaAlteracao: TDateTime;
  FStatus: string;

  private

  public
    property id:Integer read FCodigo;
    property descricao: string read FDescricao write FDescricao;
    property qtdeCaracteres: Integer read FQtdeCaracteres write FQtdeCaracteres;
    property mascara: string read FMascara write FMascara;
    property cadastradoPor: TSessao read FCadastradoPor;
    property alteradoPor: TSessao read FAlteradoPor;
    property dataCadastro: TDateTime read FDataCadastro;
    property ultimaAlteracao: TDateTime read FUltimaAlteracao;
    property status: string read FStatus;

end;

implementation

{ TTipoDocumento }

end.
