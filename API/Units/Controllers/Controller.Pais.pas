unit Controller.Pais;

interface

uses Horse, System.SysUtils, Model.Pais, System.JSON, System.Classes,
     Principal, UFuncao;

var
  pais: TPais;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  pais.limpar;
  token := '';
end;

procedure montarPais(paisItem: TPais; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(paisItem.id));
  resposta.AddPair('codigoIbge',paisItem.codigoIbge);
  resposta.AddPair('nome',paisItem.nome);
  resposta.AddPair('cadastradoPor',paisItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',paisItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(paisItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(paisItem.ultimaAlteracao));
  resposta.AddPair('status',paisItem.status);
end;

function gerarLogPais(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := pais.GerarLog('Pais',
                             procedimento,
                             imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    pais.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Pais');
    end;
  end;
end;

procedure criarConexao;
begin
  try
    pais := TPais.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Pais');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (pais.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarPaises(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  paises: TArray<TPais>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPais(Req, Res, 'buscarPaises', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    pais.id := strToIntZero(Req.Query['codigo']);
    pais.nome := Req.Query['nomePais'];
    pais.codigoIbge := Req.Query['codigoIBGE'];
    pais.status := Req.Query['status'];
    pais.limite := strToIntZero(Req.Query['limite']);
    pais.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (pais.status = '') then
  begin
    pais.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (pais.nome <> '') or
       (pais.codigoIbge <> '') or
       (pais.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    paises := pais.consultar();
    quantidade := Length(paises);

    resposta.AddPair('tipo', 'consulta paises');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(pais.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(pais.limite));
    resposta.AddPair('offset', TJSONNumber.Create(pais.offset));

    if not Assigned(paises) then
    begin
      if (Length(paises) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os paises!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarPais(paises[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      paises[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('PAIS003', 'Erro não tratado ao listar todos os paises!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pais.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarPais(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  paisConsultado: TPais;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPais(Req, Res, 'cadastrarPais', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    pais.nome := body.GetValue<string>('nomePais', '');
    pais.codigoIbge := body.GetValue<string>('codigoIBGE', '');
    pais.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (pais.nome = '') then
    begin
      erros.Add('O Nome do País deve ser informado!');
    end
    else if (Length(Trim(pais.nome)) <= 2) then
    begin
      erros.Add('O nome do País deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(pais.nome)) > 150) then
    begin
      erros.Add('O nome do País deve conter no maximo 150 caracteres validos!');
    end;

    if (Trim(pais.codigoIbge) = '') then
    begin
      erros.Add('O codigo do IBGE deve ser informado!');
    end
    else if (Length(Trim(soNumeros(pais.codigoIbge))) <> 4) then
    begin
      erros.Add('O codigo do IBGE deve conter 4 caracteres numericos validos!');
    end;

    if (erros.Text = '') then
    begin
      paisConsultado := pais.existeRegistro();

      if (Assigned(paisConsultado)) then
      begin
        erros.Add('Já existe um País [' + IntToStrSenaoZero(paisConsultado.id) +
                  ' - ' + paisConsultado.nome + '], cadastrado com esse codigo IBGE ou com esse nome!');
        paisConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PAIS006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      paisConsultado := pais.cadastrarPais();

      if Assigned(paisConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Pais');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pais.registrosAfetados));
        montarPais(paisConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        paisConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Pais!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Pais!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pais.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarPais(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  paisConsultado: TPais;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPais(Req, Res, 'alterarPais', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    pais.nome := body.GetValue<string>('nomePais', '');
    pais.codigoIbge := body.GetValue<string>('codigoIBGE', '');
    pais.status := body.GetValue<string>('status', 'A');
    pais.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pais.id > 0) then
    begin
      erros.Add('O Codigo do País deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (pais.nome = '') then
    begin
      erros.Add('O Nome do País deve ser informado!');
    end
    else if (Length(Trim(pais.nome)) <= 2) then
    begin
      erros.Add('O nome do País deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(pais.nome)) > 150) then
    begin
      erros.Add('O nome do País deve conter no maximo 150 caracteres validos!');
    end;

    if (Trim(pais.codigoIbge) = '') then
    begin
      erros.Add('O codigo do IBGE deve ser informado!');
    end
    else if (Length(Trim(soNumeros(pais.codigoIbge))) <> 4) then
    begin
      erros.Add('O codigo do IBGE deve conter 4 caracteres numericos validos!');
    end;

    if (pais.status <> 'A') and (pais.status <> 'I') then
    begin
      erros.Add('O Status do País informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      paisConsultado := pais.consultarChave();

      if not (Assigned(paisConsultado)) then
      begin
        erros.Add('Nenhum País encontrado com o codigo [' + IntToStrSenaoZero(pais.id) + ']!');
      end
      else
      begin
        paisConsultado.Destroy;
        paisConsultado := pais.existeRegistro();

        if (Assigned(paisConsultado)) then
        begin
          erros.Add('Já existe um País [' + IntToStrSenaoZero(paisConsultado.id) +
                  ' - ' + paisConsultado.nome + '], cadastrado com esse codigo IBGE ou com esse nome!');
          paisConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PAIS013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      paisConsultado := pais.alterarPais();

      if Assigned(paisConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Pais');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pais.registrosAfetados));
        montarPais(paisConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        paisConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Pais!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Pais!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pais.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarPais(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  paisConsultado: TPais;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPais(Req, Res, 'inativarPais', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    pais.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(JsonErro('PAIS015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pais.id > 0) then
    begin
      erros.Add('O Codigo do País deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      paisConsultado := pais.consultarChave();

      if not (Assigned(paisConsultado)) then
      begin
        erros.Add('Nenhum País encontrado com o codigo [' + IntToStrSenaoZero(pais.id) + ']!');
      end
      else
      begin
        paisConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PAIS016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      paisConsultado := pais.inativarPais();

      if Assigned(paisConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Pais');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pais.registrosAfetados));
        montarPais(paisConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        paisConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Pais!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Pais!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PAIS017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pais.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/pais', buscarPaises);
  THorse.Post('/pais', cadastrarPais);
  THorse.Put('/pais/:id', alterarPais);
  THorse.Delete('/pais/:id', inativarPais);
end;

end.
