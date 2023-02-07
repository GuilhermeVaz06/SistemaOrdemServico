unit Controller.TipoDocumento;

interface

uses Horse, System.SysUtils, Model.TipoDocumento, System.JSON, System.Classes,
     Principal, UFuncao;

var
  tipoDocumento: TTipoDocumento;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  tipoDocumento.limpar;
  token := '';
end;

procedure montarTipoDocumento(tipoDocumentoItem: TTipoDocumento; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(tipoDocumentoItem.id));
  resposta.AddPair('descricao',tipoDocumentoItem.descricao);
  resposta.AddPair('qtdeCaracteres', TJSONNumber.Create(tipoDocumentoItem.qtdeCaracteres));
  resposta.AddPair('mascara',tipoDocumentoItem.mascara);
  resposta.AddPair('cadastradoPor',tipoDocumentoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',tipoDocumentoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(tipoDocumentoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(tipoDocumentoItem.ultimaAlteracao));
  resposta.AddPair('status',tipoDocumentoItem.status);
end;

function gerarLogTipoDocumento(Req: THorseRequest; Res: THorseResponse; procedimento: string): Integer;
var
  resposta: TJSONObject;
  mensagem: string;
begin
  resposta := TJSONObject.Create;

  try
    Result := tipoDocumento.GerarLog('TipoDocumento',
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;

  FreeAndNil(resposta);
end;

procedure criarConexao;
begin
  try
    tipoDocumento := TTipoDocumento.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Tipo Documento');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    tipoDocumento.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Tipo Documento');
    end;
  end;
end;

function verificarToken(Res: THorseResponse): Boolean;
var
  resposta: TJSONObject;
  mensagem: string;
begin
  Result := True;
  resposta := TJSONObject.Create;

  try
    if not (tipoDocumento.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;

  FreeAndNil(resposta);
end;

procedure buscarTipoDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  tipoDocumentos: TArray<TTipoDocumento>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoDocumento(Req, Res, 'buscarTipoDocumento');

  if (continuar) then
  try
    token := Req.Headers['token'];
    tipoDocumento.id := strToIntZero(Req.Query['codigo']);
    tipoDocumento.descricao := Req.Query['descricao'];
    tipoDocumento.qtdeCaracteres := strToIntZero(Req.Query['qtdeCaracteres']);
    tipoDocumento.mascara := Req.Query['mascara'];
    tipoDocumento.status := Req.Query['status'];
    tipoDocumento.limite := strToIntZero(Req.Query['limite']);
    tipoDocumento.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (tipoDocumento.status = '') then
  begin
    tipoDocumento.status := 'A';
  end;

  if (continuar) and (verificarToken(res)) then
  try
    if (tipoDocumento.descricao <> '') or
       (tipoDocumento.qtdeCaracteres > 0) or
       (tipoDocumento.mascara <> '') or
       (tipoDocumento.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    tipoDocumentos := tipoDocumento.consultar();
    quantidade := Length(tipoDocumentos);

    resposta.AddPair('tipo', 'consulta Tipo Documentos');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(tipoDocumento.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(tipoDocumento.limite));
    resposta.AddPair('offset', TJSONNumber.Create(tipoDocumento.offset));

    if not Assigned(tipoDocumentos) then
    begin
      if (Length(tipoDocumentos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Tipos de Documentos!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarTipoDocumento(tipoDocumentos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      tipoDocumentos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('TIPODOCUMENTO003', 'Erro não tratado ao listar todos os Tipos de Documentos!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoDocumento.atualizarLog(codigoLog, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarTipoDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  tipoDocumentoConsultado: TTipoDocumento;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoDocumento(Req, Res, 'cadastrarTipoDocumento');

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    tipoDocumento.descricao := body.GetValue<string>('descricao', '');
    tipoDocumento.qtdeCaracteres := body.GetValue<Integer>('qtdeCaracteres', 0);
    tipoDocumento.mascara := body.GetValue<string>('mascara', '');
    tipoDocumento.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (tipoDocumento.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(tipoDocumento.descricao)) <= 2) then
    begin
      erros.Add('A descrição deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(tipoDocumento.descricao)) > 10) then
    begin
      erros.Add('A descrição deve conter no maximo 10 caracteres validos!');
    end;

    if (Trim(tipoDocumento.mascara) = '') then
    begin
      erros.Add('A Mascara deve ser informada!');
    end
    else if (Length(Trim(tipoDocumento.mascara)) <= 2) then
    begin
      erros.Add('A Mascara deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(tipoDocumento.mascara)) > 30) then
    begin
      erros.Add('A Mascara deve conter no maximo 30 caracteres validos!');
    end;

    if not (tipoDocumento.qtdeCaracteres > 0) then
    begin
      erros.Add('A quantidade de caracteres deve ser informada!');
    end;

    if (erros.Text = '') then
    begin
      tipoDocumentoConsultado := tipoDocumento.existeRegistro();

      if (Assigned(tipoDocumentoConsultado)) then
      begin
        erros.Add('Já existe um Tipo de Documento [' + IntToStrSenaoZero(tipoDocumentoConsultado.id) +
                  ' - ' + tipoDocumentoConsultado.descricao + '], cadastrado com essa descrição!');
        tipoDocumentoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('TIPODOCUMENTO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      tipoDocumentoConsultado := tipoDocumento.cadastrarTipoDocumento();

      if Assigned(tipoDocumentoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Tipo de Documento');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(tipoDocumento.registrosAfetados));
        montarTipoDocumento(tipoDocumentoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        tipoDocumentoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Tipo de Documento!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Tipo de Documento!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoDocumento.atualizarLog(codigoLog, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarTipoDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  tipoDocumentoConsultado: TTipoDocumento;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoDocumento(Req, Res, 'alterarTipoDocumento');

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    tipoDocumento.descricao := body.GetValue<string>('descricao', '');
    tipoDocumento.qtdeCaracteres := body.GetValue<Integer>('qtdeCaracteres', 0);
    tipoDocumento.mascara := body.GetValue<string>('mascara', '');
    tipoDocumento.status := body.GetValue<string>('status', 'A');
    tipoDocumento.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (tipoDocumento.id > 0) then
    begin
      erros.Add('O Codigo do tipo de documento deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (tipoDocumento.descricao = '') then
    begin
      erros.Add('A descrição do Tipo do documento deve ser informada!');
    end
    else if (Length(Trim(tipoDocumento.descricao)) <= 3) then
    begin
      erros.Add('A descrição do Tipo do documento deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(tipoDocumento.descricao)) > 10) then
    begin
      erros.Add('A descrição do Tipo do documento deve conter no maximo 10 caracteres validos!');
    end;

    if (Trim(tipoDocumento.mascara) = '') then
    begin
      erros.Add('A Mascara deve ser informada!');
    end
    else if (Length(Trim(tipoDocumento.mascara)) <= 3) then
    begin
      erros.Add('A Mascara deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(tipoDocumento.mascara)) > 30) then
    begin
      erros.Add('A Mascara deve conter no maximo 30 caracteres validos!');
    end;

    if not (tipoDocumento.qtdeCaracteres > 0) then
    begin
      erros.Add('A quantidade de caracteres deve ser informada!');
    end;

    if (tipoDocumento.status <> 'A') and (tipoDocumento.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      tipoDocumentoConsultado := tipoDocumento.consultarChave();

      if not (Assigned(tipoDocumentoConsultado)) then
      begin
        erros.Add('Nenhum tipo de documento encontrado com o codigo [' + IntToStrSenaoZero(tipoDocumento.id) + ']!');
      end
      else
      begin
        tipoDocumentoConsultado.Destroy;
        tipoDocumentoConsultado := tipoDocumento.existeRegistro();

        if (Assigned(tipoDocumentoConsultado)) then
        begin
          erros.Add('Já existe um tipo de documento [' + IntToStrSenaoZero(tipoDocumentoConsultado.id) +
                  ' - ' + tipoDocumentoConsultado.descricao + '], cadastrado com essa descrição!');
          tipoDocumentoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('TIPODOCUMENTO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      tipoDocumentoConsultado := tipoDocumento.alterarTipoDocumento();

      if Assigned(tipoDocumentoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Tipo de Documento');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(tipoDocumento.registrosAfetados));
        montarTipoDocumento(tipoDocumentoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        tipoDocumentoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Tipo de Documento!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Tipo de Documento!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoDocumento.atualizarLog(codigoLog, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarTipoDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  tipoDocumentoConsultado: TTipoDocumento;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoDocumento(Req, Res, 'inativarTipoDocumento');

  if (continuar) then
  try
    token := Req.Headers['token'];
    tipoDocumento.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (tipoDocumento.id > 0) then
    begin
      erros.Add('O Codigo do tipo de documento deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      tipoDocumentoConsultado := tipoDocumento.consultarChave();

      if not (Assigned(tipoDocumentoConsultado)) then
      begin
        erros.Add('Nenhuma tipo de documento encontrado com o codigo [' + IntToStrSenaoZero(tipoDocumento.id) + ']!');
      end
      else
      begin
        tipoDocumentoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('TIPODOCUMENTO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      tipoDocumentoConsultado := tipoDocumento.inativarTipoDocumento();

      if Assigned(tipoDocumentoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de tipo de documento');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(tipoDocumento.registrosAfetados));
        montarTipoDocumento(tipoDocumentoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        tipoDocumentoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um tipo de documento!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um tipo de documento!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPODOCUMENTO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoDocumento.atualizarLog(codigoLog, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/tipoDocumento', buscarTipoDocumento);
  THorse.Post('/tipoDocumento', cadastrarTipoDocumento);
  THorse.Put('/tipoDocumento/:id', alterarTipoDocumento);
  THorse.Delete('/tipoDocumento/:id', inativarTipoDocumento);
end;

end.
