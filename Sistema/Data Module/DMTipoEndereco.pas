unit DMTipoEndereco;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMTipoEndereco = class(TDataModule)
    DTipoEndereco: TDataSource;
    TTipoEndereco: TFDMemTable;
    TTipoEnderecocodigo: TIntegerField;
    TTipoEnderecocadastradoPor: TStringField;
    TTipoEnderecoalteradoPor: TStringField;
    TTipoEnderecodataCadastro: TStringField;
    TTipoEnderecodataAlteracao: TStringField;
    TTipoEnderecostatus: TStringField;
    TTipoEnderecodescricao: TStringField;
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarTipoEndereco: Boolean;
    function alterarTipoEndereco: Boolean;
    function inativarTipoEndereco: Boolean;
  end;

var
  FDMTipoEndereco: TFDMTipoEndereco;

implementation

uses UFuncao, UConexao, TipoEndereco;

{$R *.dfm}

function TFDMTipoEndereco.cadastrarTipoEndereco: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'tipoEndereco';
  Conexao.AtribuirBody('descricao', TTipoEnderecodescricao.Value);
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
      TTipoEnderecocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TTipoEnderecocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TTipoEnderecoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TTipoEnderecodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TTipoEnderecodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TTipoEnderecostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMTipoEndereco.alterarTipoEndereco: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'tipoEndereco/' + IntToStrSenaoZero(TTipoEnderecocodigo.Value);
  Conexao.AtribuirBody('descricao', TTipoEnderecodescricao.Value);
  Conexao.AtribuirBody('status', TTipoEnderecostatus.Value);
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
      TTipoEnderecocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TTipoEnderecocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TTipoEnderecoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TTipoEnderecodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TTipoEnderecodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TTipoEnderecostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMTipoEndereco.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FTipoEndereco)) then
  begin
    if (FTipoEndereco.ELocalizarDescricao.Text <> '') then
    begin
      Conexao.AtribuirParametro('descricao', FTipoEndereco.ELocalizarDescricao.Text);
    end;

    if FTipoEndereco.CBMostrarInativo.Checked then
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
  Conexao.url := 'tipoEndereco';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TTipoEndereco);
  end
  else
  begin
    TTipoEndereco.Close;
    TTipoEndereco.Open;
  end;

  Conexao.Destroy;
end;

function TFDMTipoEndereco.inativarTipoEndereco: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'tipoEndereco/' + IntToStrSenaoZero(TTipoEnderecocodigo.Value);
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
