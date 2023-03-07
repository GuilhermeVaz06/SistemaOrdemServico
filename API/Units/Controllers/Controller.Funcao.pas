unit Controller.Funcao;

interface

uses Horse, System.SysUtils, Model.Funcao, System.JSON, System.Classes,
     Principal, UFuncao;

var
  funcao: TFuncao;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  funcao.limpar;
  token := '';
end;

procedure montarFuncao(funcaoItem: TFuncao; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(funcaoItem.id));
  resposta.AddPair('descricao',funcaoItem.descricao);
  resposta.AddPair('valorHoraNormal',TJSONNumber.Create(funcaoItem.valorHoraNormal));
  resposta.AddPair('valorHora50',TJSONNumber.Create(funcaoItem.valorHora50));
  resposta.AddPair('valorHora100',TJSONNumber.Create(funcaoItem.valorHora100));
  resposta.AddPair('valorAdicionalNoturno',TJSONNumber.Create(funcaoItem.valorAdicionalNoturno));
  resposta.AddPair('cadastradoPor',funcaoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',funcaoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(funcaoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(funcaoItem.ultimaAlteracao));
  resposta.AddPair('status',funcaoItem.status);
end;

function gerarLogFuncao(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := funcao.GerarLog('funcao',
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    funcao := TFuncao.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Função');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    funcao.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Função');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;
  try
    if not (funcao.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarFuncao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  funcaos: TArray<TFuncao>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncao(Req, Res, 'buscarFuncao', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    funcao.id := strToIntZero(Req.Query['codigo']);
    funcao.valorHoraNormal := PontoVirgula(Req.Query['valorHoraNormal']);
    funcao.valorHora50 := PontoVirgula(Req.Query['valorHora50']);
    funcao.valorHora100 := PontoVirgula(Req.Query['valorHora100']);
    funcao.valorAdicionalNoturno := PontoVirgula(Req.Query['valorAdicionalNoturno']);
    funcao.descricao := Req.Query['descricao'];
    funcao.status := Req.Query['status'];
    funcao.limite := strToIntZero(Req.Query['limite']);
    funcao.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (funcao.status = '') then
  begin
    funcao.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (funcao.descricao <> '') or
       (funcao.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    funcaos := funcao.consultar();
    quantidade := Length(funcaos);

    resposta.AddPair('tipo', 'consulta Função');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(funcao.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(funcao.limite));
    resposta.AddPair('offset', TJSONNumber.Create(funcao.offset));

    if not Assigned(funcaos) then
    begin
      if (Length(funcaos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar as Função!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarFuncao(funcaos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      funcaos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('FUNCAO003', 'Erro não tratado ao listar todos as Função!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcao.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarFuncao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  funcaoConsultado: TFuncao;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncao(Req, Res, 'cadastrarFuncao', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    funcao.descricao := body.GetValue<string>('descricao', '');
    funcao.valorHoraNormal := body.GetValue<Double>('valorHoraNormal', 0);
    funcao.valorHora50 := body.GetValue<Double>('valorHora50', 0);
    funcao.valorHora100 := body.GetValue<Double>('valorHora100', 0);
    funcao.valorAdicionalNoturno := body.GetValue<Double>('valorAdicionalNoturno', 0);
    funcao.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (funcao.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(funcao.descricao)) <= 1) then
    begin
      erros.Add('A descrição deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(funcao.descricao)) > 150) then
    begin
      erros.Add('A descrição deve conter no maximo 150 caracteres validos!');
    end;

    if (erros.Text = '') then
    begin
      funcaoConsultado := funcao.existeRegistro();

      if (Assigned(funcaoConsultado)) then
      begin
        erros.Add('Já existe uma função [' + IntToStrSenaoZero(funcaoConsultado.id) +
                  ' - ' + funcaoConsultado.descricao +
                  ' - ' + funcaoConsultado.status + '], cadastrado com essa descrição!');
        funcaoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('FUNCAO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      funcaoConsultado := funcao.cadastrarFuncao();

      if Assigned(funcaoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Função');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(funcao.registrosAfetados));
        montarFuncao(funcaoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        funcaoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar uma Função!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar uma Função!!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcao.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarFuncao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  funcaoConsultado: TFuncao;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncao(Req, Res, 'alterarFuncao', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    funcao.descricao := body.GetValue<string>('descricao', '');
    funcao.valorHoraNormal := body.GetValue<Double>('valorHoraNormal', 0);
    funcao.valorHora50 := body.GetValue<Double>('valorHora50', 0);
    funcao.valorHora100 := body.GetValue<Double>('valorHora100', 0);
    funcao.valorAdicionalNoturno := body.GetValue<Double>('valorAdicionalNoturno', 0);
    funcao.status := body.GetValue<string>('status', 'A');
    funcao.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (funcao.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (funcao.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(funcao.descricao)) <= 2) then
    begin
      erros.Add('A descrição deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(funcao.descricao)) > 150) then
    begin
      erros.Add('A descrição deve conter no maximo 150 caracteres validos!');
    end;

    if (funcao.status <> 'A') and (funcao.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      funcaoConsultado := funcao.consultarChave();

      if not (Assigned(funcaoConsultado)) then
      begin
        erros.Add('Nenhuma função encontrado com o codigo [' + IntToStrSenaoZero(funcao.id) + ']!');
      end
      else
      begin
        funcaoConsultado.Destroy;
        funcaoConsultado := funcao.existeRegistro();

        if (Assigned(funcaoConsultado)) then
        begin
          erros.Add('Já existe uma função [' + IntToStrSenaoZero(funcaoConsultado.id) +
                  ' - ' + funcaoConsultado.descricao +
                  ' - ' + funcaoConsultado.status + '], cadastrado com essa descrição!');
          funcaoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('FUNCAO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      funcaoConsultado := funcao.alterarFuncao();

      if Assigned(funcaoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Função');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(funcao.registrosAfetados));
        montarFuncao(funcaoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        funcaoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar uma função!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar uma função!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcao.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarFuncao(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  funcaoConsultado: TFuncao;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncao(Req, Res, 'inativarFuncao', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    funcao.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (funcao.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      funcaoConsultado := funcao.consultarChave();

      if not (Assigned(funcaoConsultado)) then
      begin
        erros.Add('Nenhuma função encontrada com o codigo [' + IntToStrSenaoZero(funcao.id) + ']!');
      end
      else
      begin
        funcaoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('FUNCAO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      funcaoConsultado := funcao.inativarFuncao();

      if Assigned(funcaoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Função');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(funcao.registrosAfetados));
        montarFuncao(funcaoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        funcaoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar uma função!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar uma função!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCAO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcao.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/funcao', buscarFuncao);
  THorse.Post('/funcao', cadastrarFuncao);
  THorse.Put('/funcao/:id', alterarFuncao);
  THorse.Delete('/funcao/:id', inativarFuncao);
end;

end.
