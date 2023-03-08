unit DMGrupo;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, REST.Types,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Classes,
  System.JSON, System.SysUtils;

type
  TFDMGrupo = class(TDataModule)
    DGrupo: TDataSource;
    TGrupo: TFDMemTable;
    TGrupocodigo: TIntegerField;
    TGrupocadastradoPor: TStringField;
    TGrupoalteradoPor: TStringField;
    TGrupodataCadastro: TStringField;
    TGrupodataAlteracao: TStringField;
    TGrupostatus: TStringField;
    TGrupodescricao: TStringField;
  private

  public
    procedure consultarDados(codigo: integer);
    function cadastrarGrupo: Boolean;
    function alterarGrupo: Boolean;
    function inativarGrupo: Boolean;
  end;

var
  FDMGrupo: TFDMGrupo;

implementation

uses UFuncao, UConexao, Grupo;

{$R *.dfm}

function TFDMGrupo.cadastrarGrupo: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPOST;
  Conexao.url := 'grupo';
  Conexao.AtribuirBody('descricao', TGrupodescricao.Value);
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
      TGrupocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TGrupocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TGrupoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TGrupodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TGrupodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TGrupostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

function TFDMGrupo.alterarGrupo: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmPUT;
  Conexao.url := 'grupo/' + IntToStrSenaoZero(TGrupocodigo.Value);
  Conexao.AtribuirBody('descricao', TGrupodescricao.Value);
  Conexao.AtribuirBody('status', TGrupostatus.Value);
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
      TGrupocodigo.Value := json.GetValue<Integer>('codigo', 0);
      TGrupocadastradoPor.Value := json.GetValue<string>('cadastradoPor', '');
      TGrupoalteradoPor.Value := json.GetValue<string>('alteradoPor', '');
      TGrupodataCadastro.Value := json.GetValue<string>('dataCadastro', '');
      TGrupodataAlteracao.Value := json.GetValue<string>('dataAlteracao', '');
      TGrupostatus.Value := json.GetValue<string>('status', 'A');

      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

  Conexao.Destroy;
end;

procedure TFDMGrupo.consultarDados(codigo: integer);
var
  Conexao: TConexao;
  master, item: TJSONArray;
  json: TJSONValue;
  limite, offset: integer;
  continuar: Boolean;
begin
  Conexao := TConexao.Create;

  if (Assigned(FGrupo)) then
  begin
    if (FGrupo.ELocalizarDescricao.Text <> '') then
    begin
      Conexao.AtribuirParametro('descricao', FGrupo.ELocalizarDescricao.Text);
    end;

    if FGrupo.CBMostrarInativo.Checked then
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
  Conexao.url := 'grupo';
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
    converterArrayJsonQuery(converterJsonArrayRestResponse(master), TGrupo);
  end
  else
  begin
    TGrupo.Close;
    TGrupo.Open;
  end;

  Conexao.Destroy;
end;

function TFDMGrupo.inativarGrupo: Boolean;
var
  Conexao: TConexao;
  json: TJSONValue;
begin
  Conexao := TConexao.Create;

  Conexao.metodo := rmDELETE;
  Conexao.url := 'grupo/' + IntToStrSenaoZero(TGrupocodigo.Value);
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
