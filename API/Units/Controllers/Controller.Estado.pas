unit Controller.Estado;

interface

uses Horse, System.SysUtils, Model.Estado, System.JSON, System.Classes,
     Principal, UFuncao;

var
  estado: TEstado;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  estado.limpar;
  token := '';
end;

procedure montarEstado(estadoItem: TEstado; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(estadoItem.id));
  resposta.AddPair('codigoPais', TJSONNumber.Create(estadoItem.pais.id));
  resposta.AddPair('nomePais',estadoItem.pais.nome);
  resposta.AddPair('codigoIbge',estadoItem.codigoIbge);
  resposta.AddPair('nome',estadoItem.nome);
  resposta.AddPair('cadastradoPor',estadoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',estadoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(estadoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(estadoItem.ultimaAlteracao));
  resposta.AddPair('status',estadoItem.status);
end;

function gerarLogEstado(Req: THorseRequest; Res: THorseResponse; procedimento: string): Integer;
var
  resposta: TJSONObject;
  mensagem: string;
begin
  resposta := TJSONObject.Create;

  try
    Result := estado.GerarLog('Estado',
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO018', mensagem))));
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
    estado := TEstado.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Estado');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    estado.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Estado');
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
    if not (estado.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;

  FreeAndNil(resposta);
end;

procedure buscarEstados(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  estados: TArray<TEstado>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEstado(Req, Res, 'buscarEstados');

  if (continuar) then
  try
    token := Req.Headers['token'];
    estado.id := strToIntZero(Req.Query['codigo']);
    estado.nome := Req.Query['nomeEstado'];
    estado.pais.nome := Req.Query['nomePais'];
    estado.pais.id := strToIntZero(Req.Query['codigoPais']);
    estado.codigoIbge := Req.Query['codigoIBGE'];
    estado.status := Req.Query['status'];
    estado.limite := strToIntZero(Req.Query['limite']);
    estado.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (estado.status = '') then
  begin
    estado.status := 'A';
  end;

  if (continuar) and (verificarToken(res)) then
  try
    if (estado.nome <> '') or
       (estado.codigoIbge <> '') or
       (estado.pais.nome <> '') or
       (estado.pais.id > 0) or
       (estado.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    estados := estado.consultar();
    quantidade := Length(estados);

    resposta.AddPair('tipo', 'consulta estados');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(estado.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(estado.limite));
    resposta.AddPair('offset', TJSONNumber.Create(estado.offset));

    if not Assigned(estados) then
    begin
      if (Length(estados) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os estados!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarEstado(estados[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      estados[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('ESTADO003', 'Erro não tratado ao listar todos os estados!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  estado.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarEstado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  estadoConsultado: TEstado;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEstado(Req, Res, 'cadastrarEstado');

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    estado.nome := body.GetValue<string>('nomeEstado', '');
    estado.pais.id := body.GetValue<Integer>('codigoPais', 0);
    estado.codigoIbge := body.GetValue<string>('codigoIBGE', '');
    estado.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (estado.nome = '') then
    begin
      erros.Add('O Nome do Estado deve ser informado!');
    end
    else if (Length(Trim(estado.nome)) <= 2) then
    begin
      erros.Add('O nome do Estado deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(estado.nome)) > 150) then
    begin
      erros.Add('O nome do Estado deve conter no maximo 150 caracteres validos!');
    end;

    if (Trim(estado.codigoIbge) = '') then
    begin
      erros.Add('O codigo do IBGE deve ser informado!');
    end
    else if (Length(Trim(soNumeros(estado.codigoIbge))) <> 2) then
    begin
      erros.Add('O codigo do IBGE deve conter 2 caracteres numericos validos!');
    end;

    if not (estado.pais.id > 0) then
    begin
      erros.Add('O Pais do Estado deve ser informado!');
    end;

    if (erros.Text = '') then
    begin
      estadoConsultado := estado.existeRegistro();

      if (Assigned(estadoConsultado)) then
      begin
        erros.Add('Já existe um Estado [' + IntToStrSenaoZero(estadoConsultado.id) +
                  ' - ' + estadoConsultado.nome + '], cadastrado com esse codigo IBGE ou com esse nome!');
        estadoConsultado.Destroy;
      end
      else
      begin
        estadoConsultado := TEstado.Create;
        estadoConsultado.pais.Destroy;
        estadoConsultado.pais := estado.pais.consultarChave();

        if not (Assigned(estadoConsultado.pais)) then
        begin
          erros.Add('Nenhum País encontrado com o codigo [' + IntToStrSenaoZero(estado.pais.id) + ']!');
        end;

        estadoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ESTADO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      estadoConsultado := estado.cadastrarEstado();

      if Assigned(estadoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Estado');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(estado.registrosAfetados));
        montarEstado(estadoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        estadoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Estado!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Estado!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  estado.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarEstado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  estadoConsultado: TEstado;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEstado(Req, Res, 'alterarEstado');

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    estado.nome := body.GetValue<string>('nomeEstado', '');
    estado.pais.id := body.GetValue<Integer>('codigoPais', 0);
    estado.codigoIbge := body.GetValue<string>('codigoIBGE', '');
    estado.status := body.GetValue<string>('status', 'A');
    estado.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (estado.id > 0) then
    begin
      erros.Add('O Codigo do Estado deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (estado.nome = '') then
    begin
      erros.Add('O Nome do Estado deve ser informado!');
    end
    else if (Length(Trim(estado.nome)) <= 2) then
    begin
      erros.Add('O nome do Estado deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(estado.nome)) > 150) then
    begin
      erros.Add('O nome do Estado deve conter no maximo 150 caracteres validos!');
    end;

    if (Trim(estado.codigoIbge) = '') then
    begin
      erros.Add('O codigo do IBGE deve ser informado!');
    end
    else if (Length(Trim(soNumeros(estado.codigoIbge))) <> 2) then
    begin
      erros.Add('O codigo do IBGE deve conter 2 caracteres numericos validos!');
    end;

    if not (estado.pais.id > 0) then
    begin
      erros.Add('O Pais do Estado deve ser informado!');
    end;

    if (estado.status <> 'A') and (estado.status <> 'I') then
    begin
      erros.Add('O Status do Estado informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      estadoConsultado := estado.consultarChave();

      if not (Assigned(estadoConsultado)) then
      begin
        erros.Add('Nenhum Estado encontrado com o codigo [' + IntToStrSenaoZero(estado.id) + ']!');
      end
      else
      begin
        estadoConsultado.Destroy;
        estadoConsultado := estado.existeRegistro();

        if (Assigned(estadoConsultado)) then
        begin
          erros.Add('Já existe um Estado [' + IntToStrSenaoZero(estadoConsultado.id) +
                  ' - ' + estadoConsultado.nome + '], cadastrado com esse codigo IBGE ou com esse nome!');
          estadoConsultado.Destroy;
        end;
      end;

      estadoConsultado := TEstado.Create;
      estadoConsultado.pais.Destroy;
      estadoConsultado.pais := estado.pais.consultarChave();

      if not (Assigned(estadoConsultado.pais)) then
      begin
        erros.Add('Nenhum País encontrado com o codigo [' + IntToStrSenaoZero(estado.pais.id) + ']!');
      end;

      estadoConsultado.Destroy;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ESTADO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      estadoConsultado := estado.alterarEstado();

      if Assigned(estadoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Estado');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(estado.registrosAfetados));
        montarEstado(estadoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        estadoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Estado!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Estado!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  estado.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarEstado(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  estadoConsultado: TEstado;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEstado(Req, Res, 'inativarEstado');

  if (continuar) then
  try
    token := Req.Headers['token'];
    estado.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (estado.id > 0) then
    begin
      erros.Add('O Codigo do Estado deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      estadoConsultado := estado.consultarChave();

      if not (Assigned(estadoConsultado)) then
      begin
        erros.Add('Nenhum Estado encontrado com o codigo [' + IntToStrSenaoZero(estado.id) + ']!');
      end
      else
      begin
        estadoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ESTADO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      estadoConsultado := estado.inativarEstado();

      if Assigned(estadoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Estado');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(estado.registrosAfetados));
        montarEstado(estadoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        estadoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Estado!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Estado!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ESTADO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  estado.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/estado', buscarEstados);
  THorse.Post('/estado', cadastrarEstado);
  THorse.Put('/estado/:id', alterarEstado);
  THorse.Delete('/estado/:id', inativarEstado);
end;

end.
