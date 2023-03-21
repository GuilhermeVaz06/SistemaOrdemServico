unit DMOrdemServico;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils, System.MaskUtils;

type
  TFDMOrdemServico = class(TDataModule)
    DOrdemServico: TDataSource;
    TOrdemServico: TFDMemTable;
    TOrdemServicocodigo: TIntegerField;
    TOrdemServicocadastradoPor: TStringField;
    TOrdemServicoalteradoPor: TStringField;
    TOrdemServicodataCadastro: TStringField;
    TOrdemServicodataAlteracao: TStringField;
    TOrdemServicoempresaCodigo: TIntegerField;
    TOrdemServicoempresaNome: TStringField;
    TOrdemServicoclienteCodigo: TIntegerField;
    TOrdemServicoclienteNome: TStringField;
    TOrdemServicoenderecoCodigo: TIntegerField;
    TOrdemServicoenderecoTipo: TStringField;
    TOrdemServicoenderecoCEP: TStringField;
    TOrdemServicoenderecoLongradouro: TStringField;
    TOrdemServicoenderecoNumero: TStringField;
    TOrdemServicoenderecoBairro: TStringField;
    TOrdemServicoenderecoComplemento: TStringField;
    TOrdemServicoenderecoObservacao: TMemoField;
    TOrdemServicoenderecoCidade: TStringField;
    TOrdemServicoenderecoEstado: TStringField;
    TOrdemServicoenderecoPais: TStringField;
    TOrdemServicotransportadoraCodigo: TIntegerField;
    TOrdemServicotransportadoraNome: TStringField;
    TOrdemServicofinalidade: TStringField;
    TOrdemServicotipoFrete: TStringField;
    TOrdemServicodetalhamento: TMemoField;
    TOrdemServicosituacao: TStringField;
    TOrdemServicoobservacao: TMemoField;
    TOrdemServicodesconto: TFloatField;
    TOrdemServicostatus: TStringField;
    TOrdemServicodataPrazoEntrega: TStringField;
    TOrdemServicodataOrdemServico: TStringField;
    procedure GetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarPessoa: Boolean;
    function alterarPessoa: Boolean;
  end;

var
  FDMOrdemServico: TFDMOrdemServico;

implementation

uses UFuncao, UConexao, OrdemServico;

{$R *.dfm}

function TFDMOrdemServico.cadastrarPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'ordemServico';
  Conexao.AtribuirBody('empresaCodigo', IntToStrSenaoZero(TOrdemServicoempresaCodigo.Value));
  Conexao.AtribuirBody('clienteCodigo', IntToStrSenaoZero(TOrdemServicoclienteCodigo.Value));
  Conexao.AtribuirBody('enderecoCodigo', IntToStrSenaoZero(TOrdemServicoenderecoCodigo.Value));
  Conexao.AtribuirBody('transportadoraCodigo', IntToStrSenaoZero(TOrdemServicotransportadoraCodigo.Value));
  Conexao.AtribuirBody('finalidade', TOrdemServicofinalidade.Value);
  Conexao.AtribuirBody('tipoFrete', TOrdemServicotipoFrete.Value);
  Conexao.AtribuirBody('detalhamento', TOrdemServicodetalhamento.Value);
  Conexao.AtribuirBody('observacao', TOrdemServicoobservacao.Value);
  Conexao.AtribuirBody('dataEntrega', TOrdemServicodataPrazoEntrega.Value);
  Conexao.AtribuirBody('dataOrdem', TOrdemServicodataOrdemServico.Value);
  Conexao.AtribuirBody('desconto', VirgulaPonto(TOrdemServicodesconto.Value));
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
      TOrdemServicocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TOrdemServicocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TOrdemServicoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TOrdemServicodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TOrdemServicodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TOrdemServicostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMOrdemServico.alterarPessoa: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'ordemServico/' + IntToStrSenaoZero(TOrdemServicocodigo.Value);
  Conexao.AtribuirBody('empresaCodigo', IntToStrSenaoZero(TOrdemServicoempresaCodigo.Value));
  Conexao.AtribuirBody('clienteCodigo', IntToStrSenaoZero(TOrdemServicoclienteCodigo.Value));
  Conexao.AtribuirBody('enderecoCodigo', IntToStrSenaoZero(TOrdemServicoenderecoCodigo.Value));
  Conexao.AtribuirBody('transportadoraCodigo', IntToStrSenaoZero(TOrdemServicotransportadoraCodigo.Value));
  Conexao.AtribuirBody('finalidade', TOrdemServicofinalidade.Value);
  Conexao.AtribuirBody('tipoFrete', TOrdemServicotipoFrete.Value);
  Conexao.AtribuirBody('detalhamento', TOrdemServicodetalhamento.Value);
  Conexao.AtribuirBody('observacao', TOrdemServicoobservacao.Value);
  Conexao.AtribuirBody('dataEntrega', TOrdemServicodataPrazoEntrega.Value);
  Conexao.AtribuirBody('dataOrdem', TOrdemServicodataOrdemServico.Value);
  Conexao.AtribuirBody('desconto', VirgulaPonto(TOrdemServicodesconto.Value));
  Conexao.AtribuirBody('status', TOrdemServicostatus.Value);
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
      TOrdemServicocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TOrdemServicocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TOrdemServicoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TOrdemServicodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TOrdemServicodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TOrdemServicostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FOrdemServico)) then
  begin
    if FOrdemServico.CBMostrarInativo.Checked then
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
  Conexao.url := 'ordemServico';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TOrdemServico);
  end
  else
  begin
    TOrdemServico.Close;
    TOrdemServico.Open;
  end;

  Conexao.Destroy;
end;

procedure TFDMOrdemServico.GetText(Sender: TField;
  var Text: string; DisplayText: Boolean);
begin
  Text:= (Sender as TMemoField).Value;
end;

end.
