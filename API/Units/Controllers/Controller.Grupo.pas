unit Controller.Grupo;

interface

uses Horse, System.SysUtils, Model.Grupo, System.JSON, System.Classes,
     Principal, UFuncao;

var
  grupo: TGrupo;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  grupo.limpar;
  token := '';
end;

procedure montarGrupo(grupoItem: TGrupo; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(grupoItem.id));
  resposta.AddPair('descricao',grupoItem.descricao);
  resposta.AddPair('cadastradoPor',grupoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',grupoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(grupoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(grupoItem.ultimaAlteracao));
  resposta.AddPair('status',grupoItem.status);
end;

function gerarLogGrupo(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := grupo.GerarLog('grupo',
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    grupo := TGrupo.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Grupo');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    grupo.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Grupo');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;
  try
    if not (grupo.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  grupos: TArray<TGrupo>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogGrupo(Req, Res, 'buscarGrupo', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    grupo.id := strToIntZero(Req.Query['codigo']);
    grupo.descricao := Req.Query['descricao'];
    grupo.status := Req.Query['status'];
    grupo.limite := strToIntZero(Req.Query['limite']);
    grupo.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (grupo.status = '') then
  begin
    grupo.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (grupo.descricao <> '') or
       (grupo.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    grupos := grupo.consultar();
    quantidade := Length(grupos);

    resposta.AddPair('tipo', 'consulta Grupos');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(grupo.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(grupo.limite));
    resposta.AddPair('offset', TJSONNumber.Create(grupo.offset));

    if not Assigned(grupos) then
    begin
      if (Length(grupos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Grupos!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarGrupo(grupos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      grupos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('GRUPO003', 'Erro não tratado ao listar todos os Grupos!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  grupo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  grupoConsultado: TGrupo;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogGrupo(Req, Res, 'cadastrarGrupo', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    grupo.descricao := body.GetValue<string>('descricao', '');
    grupo.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (grupo.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(grupo.descricao)) <= 1) then
    begin
      erros.Add('A descrição deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(grupo.descricao)) > 150) then
    begin
      erros.Add('A descrição deve conter no maximo 150 caracteres validos!');
    end;

    if (erros.Text = '') then
    begin
      grupoConsultado := grupo.existeRegistro();

      if (Assigned(grupoConsultado)) then
      begin
        erros.Add('Já existe um grupo [' + IntToStrSenaoZero(grupoConsultado.id) +
                  ' - ' + grupoConsultado.descricao +
                  ' - ' + grupoConsultado.status + '], cadastrado com essa descrição!');
        grupoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('GRUPO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      grupoConsultado := grupo.cadastrarGrupo();

      if Assigned(grupoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Grupo');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(grupo.registrosAfetados));
        montarGrupo(grupoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        grupoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Grupo!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Grupo!!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  grupo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  grupoConsultado: TGrupo;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogGrupo(Req, Res, 'alterarGrupo', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    grupo.descricao := body.GetValue<string>('descricao', '');
    grupo.status := body.GetValue<string>('status', 'A');
    grupo.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (grupo.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (grupo.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(grupo.descricao)) <= 2) then
    begin
      erros.Add('A descrição deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(grupo.descricao)) > 150) then
    begin
      erros.Add('A descrição deve conter no maximo 150 caracteres validos!');
    end;

    if (grupo.status <> 'A') and (grupo.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      grupoConsultado := grupo.consultarChave();

      if not (Assigned(grupoConsultado)) then
      begin
        erros.Add('Nenhum grupo encontrado com o codigo [' + IntToStrSenaoZero(grupo.id) + ']!');
      end
      else
      begin
        grupoConsultado.Destroy;
        grupoConsultado := grupo.existeRegistro();

        if (Assigned(grupoConsultado)) then
        begin
          erros.Add('Já existe um grupo [' + IntToStrSenaoZero(grupoConsultado.id) +
                  ' - ' + grupoConsultado.descricao +
                  ' - ' + grupoConsultado.status + '], cadastrado com essa descrição!');
          grupoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('GRUPO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      grupoConsultado := grupo.alterarGrupo();

      if Assigned(grupoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Grupo');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(grupo.registrosAfetados));
        montarGrupo(grupoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        grupoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Grupo!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Grupo!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  grupo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarGrupo(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  grupoConsultado: TGrupo;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogGrupo(Req, Res, 'inativarGrupo', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    grupo.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (grupo.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      grupoConsultado := grupo.consultarChave();

      if not (Assigned(grupoConsultado)) then
      begin
        erros.Add('Nenhum grupo encontrada com o codigo [' + IntToStrSenaoZero(grupo.id) + ']!');
      end
      else
      begin
        grupoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('GRUPO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      grupoConsultado := grupo.inativarGrupo();

      if Assigned(grupoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Grupo');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(grupo.registrosAfetados));
        montarGrupo(grupoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        grupoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Grupo!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Grupo!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('GRUPO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  grupo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/grupo', buscarGrupo);
  THorse.Post('/grupo', cadastrarGrupo);
  THorse.Put('/grupo/:id', alterarGrupo);
  THorse.Delete('/grupo/:id', inativarGrupo);
end;

end.
