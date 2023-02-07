unit DMCidade;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMCidade = class(TDataModule)
    DCidade: TDataSource;
    TCidade: TFDMemTable;
    TCidadecodigo: TIntegerField;
    TCidadecodigoPais: TIntegerField;
    TCidadecodigoIbge: TStringField;
    TCidadenome: TStringField;
    TCidadecadastradoPor: TStringField;
    TCidadealteradoPor: TStringField;
    TCidadedataCadastro: TStringField;
    TCidadedataAlteracao: TStringField;
    TCidadestatus: TStringField;
    TCidadenomePais: TStringField;
    TCidadecodigoEstado: TIntegerField;
    TCidadenomeEstado: TStringField;
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarCidade: Boolean;
    function alterarCidade: Boolean;
    function inativarCidade: Boolean;
  end;

var
  FDMCidade: TFDMCidade;

implementation

uses UFuncao, UConexao, Cidade;

{$R *.dfm}

function TFDMCidade.cadastrarCidade: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'cidade';
  Conexao.AtribuirBody('nomecidade', TCidadenome.Value);
  Conexao.AtribuirBody('codigoEstado', IntToStrSenaoZero(TCidadecodigoEstado.Value));
  Conexao.AtribuirBody('codigoIBGE', TCidadecodigoIbge.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      TCidadecodigo.Value := json.GetValue<Integer>('codigo', 0);
      TCidadecadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TCidadealteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TCidadedataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TCidadedataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TCidadestatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMCidade.alterarCidade: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'cidade/' + IntToStrSenaoZero(TCidadecodigo.Value);
  Conexao.AtribuirBody('nomecidade', TCidadenome.Value);
  Conexao.AtribuirBody('codigoEstado', IntToStrSenaoZero(TCidadecodigoEstado.Value));
  Conexao.AtribuirBody('codigoIBGE', TCidadecodigoIbge.Value);
  Conexao.AtribuirBody('status', TCidadestatus.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      TCidadecodigo.Value := json.GetValue<Integer>('codigo', 0);
      TCidadecadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TCidadealteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TCidadedataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TCidadedataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TCidadestatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMCidade.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FCidade)) then
  begin
    if (FCidade.ELocalizarNome.Text <> '') then
    begin
      Conexao.AtribuirParametro('nomeCidade', FCidade.ELocalizarNome.Text);
    end;

    if (FCidade.ELocalizarCodigoIBGE.Text <> '') then
    begin
      Conexao.AtribuirParametro('codigoIBGE', FCidade.ELocalizarCodigoIBGE.Text);
    end;

    if FCidade.CBMostrarInativo.Checked then
    begin
      Conexao.AtribuirParametro('status', 'I');
    end
    else
    begin
      Conexao.AtribuirParametro('status', 'A');
    end;
  end;

  if (codigo > 0) then
  begin
    Conexao.AtribuirParametro('codigo', IntToStrSenaoZero(codigo));
  end;

  Conexao.metodo := rmGET;
  Conexao.url := 'cidade';
  master := TJSONArray.Create;
  limite := 500;
  offset := 0;

  repeat
    Conexao.AtribuirParametro('limite', IntToStrSenaoZero(limite));
    Conexao.AtribuirParametro('offset', IntToStrSenaoZero(offset));
    Conexao.Enviar;
    continuar := False;
    offset := offset + limite;

    if not (Conexao.status in[200..202]) then
    begin
      informar(Conexao.erro);
      Break;
    end
    else
    begin
      json := converterJsonTextoJsonValue(Conexao.resposta);
      item := converterJsonValueJsonArray(json, 'dados');
      continuar := json.GetValue<Boolean>('maisRegistros', False);
      copiarItemJsonArray(item, master);
    end;
  until not continuar;

  if (Assigned(master)) and (master.Count > 0) then
  begin
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TCidade);
  end
  else
  begin
    TCidade.Close;
    TCidade.Open;
  end;

  Conexao.Destroy;
end;

function TFDMCidade.inativarCidade: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'cidade/' + IntToStrSenaoZero(TCidadecodigo.Value);
  Conexao.Enviar;

  if not (Conexao.status in[200..202]) then
  begin
    informar(Conexao.erro);
    Result := False;
  end
  else
  begin
    json := converterJsonTextoJsonValue(Conexao.resposta);

    if (Assigned(json)) then
    begin
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

end.
