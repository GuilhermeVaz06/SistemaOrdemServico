unit Model.TipoPessoa;

interface

uses System.SysUtils, ZDataset, System.Classes;

type TTipoPessoa = class

  private
    FCodigo: integer;
    FDescricao: string;

  public
    constructor Create;
    destructor Destroy; override;

    property id:Integer read FCodigo write FCodigo;
    property descricao: string read FDescricao write FDescricao;

    procedure limpar;
    function consultarChave: TTipoPessoa;
end;

implementation

uses UFuncao, Principal;

{ TTipoPessoa }

function TTipoPessoa.consultarChave: TTipoPessoa;
var
  query: TZQuery;
  tipoPessoaConsultada: TTipoPessoa;
  sql: TStringList;
begin
  tipoPessoaConsultada := TTipoPessoa.Create;
  sql := TStringList.Create;
  sql.Add('SELECT CODIGO_TIPO_PESSOA, DESCRICAO');
  sql.Add('  FROM tipo_pessoa');
  sql.Add(' WHERE CODIGO_TIPO_PESSOA = ' + IntToStrSenaoZero(FCodigo));
  sql.Add(' LIMIT 1');

  query := FConexao.executarComandoDQL(sql.Text);

  if not Assigned(query)
  or (query = nil)
  or (query.RecordCount = 0) then
  begin
    tipoPessoaConsultada.Destroy;
    tipoPessoaConsultada := nil;
  end
  else
  begin
    query.First;

    tipoPessoaConsultada.FCodigo := query.FieldByName('CODIGO_TIPO_PESSOA').Value;
    tipoPessoaConsultada.FDescricao := query.FieldByName('DESCRICAO').Value;
  end;

  Result := tipoPessoaConsultada;

  FreeAndNil(sql);
end;

constructor TTipoPessoa.Create;
begin
  inherited;
end;

destructor TTipoPessoa.Destroy;
begin
  inherited;
end;

procedure TTipoPessoa.limpar;
begin
  FCodigo := 0;
  FDescricao := '';
end;

end.
