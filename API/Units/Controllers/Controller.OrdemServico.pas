unit Controller.OrdemServico;

interface

uses Horse, System.SysUtils, Model.OrdemServico, System.JSON, System.Classes,
     Principal, UFuncao;

var
  ordemServico: TOrdemServico;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  ordemServico.limpar;
  token := '';
end;

procedure montarOrdemServico(ordemServicoItem: TOrdemServico; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo', TJSONNumber.Create(ordemServicoItem.id));
  resposta.AddPair('empresaCodigo', TJSONNumber.Create(ordemServicoItem.empresa.id));
  resposta.AddPair('empresaNome', ordemServicoItem.empresa.razaoSocial);
  resposta.AddPair('clienteCodigo', TJSONNumber.Create(ordemServicoItem.cliente.id));
  resposta.AddPair('clienteNome', ordemServicoItem.cliente.razaoSocial);
  resposta.AddPair('enderecoCodigo', TJSONNumber.Create(ordemServicoItem.endereco.id));
  resposta.AddPair('enderecoTipo', ordemServicoItem.endereco.tipoEndereco.descricao);
  resposta.AddPair('enderecoCEP', ordemServicoItem.endereco.cep);
  resposta.AddPair('enderecoLongradouro', ordemServicoItem.endereco.longradouro);
  resposta.AddPair('enderecoNumero', ordemServicoItem.endereco.numero);
  resposta.AddPair('enderecoBairro', ordemServicoItem.endereco.bairro);
  resposta.AddPair('enderecoComplemento', ordemServicoItem.endereco.complemento);
  resposta.AddPair('enderecoObservacao', ordemServicoItem.endereco.observacao);
  resposta.AddPair('enderecoCidade', ordemServicoItem.endereco.cidade.nome);
  resposta.AddPair('enderecoEstado', ordemServicoItem.endereco.cidade.estado.nome);
  resposta.AddPair('enderecoPais', ordemServicoItem.endereco.cidade.estado.pais.nome);
  resposta.AddPair('transportadoraCodigo', TJSONNumber.Create(ordemServicoItem.transportador.id));
  resposta.AddPair('transportadoraNome', ordemServicoItem.transportador.razaoSocial);
  resposta.AddPair('finalidade', ordemServicoItem.finalidade);
  resposta.AddPair('tipoFrete', ordemServicoItem.tipoFrete);
  resposta.AddPair('detalhamento', ordemServicoItem.detalhamento);
  resposta.AddPair('situacao', ordemServicoItem.situacao);
  resposta.AddPair('observacao', ordemServicoItem.observacao);
  resposta.AddPair('dataPrazoEntrega', DateToStr(ordemServicoItem.dataEntrega));
  resposta.AddPair('dataOrdemServico', DateToStr(ordemServicoItem.dataOrdem));
  resposta.AddPair('desconto', TJSONNumber.Create(ordemServicoItem.desconto));
  resposta.AddPair('cadastradoPor',ordemServicoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',ordemServicoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(ordemServicoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(ordemServicoItem.ultimaAlteracao));
  resposta.AddPair('status',ordemServicoItem.status);
end;

function gerarLogOrdemServico(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := ordemServico.GerarLog('Ordem Servico',
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    ordemServico := TordemServico.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Ordem Servico');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    ordemServico.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Ordem Servico');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (ordemServico.verificarToken(token)) then
    begin
      mensagem := 'O token informado � invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarOrdensServico(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  ordensServico: TArray<TOrdemServico>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOrdemServico(Req, Res, 'buscarOrdensServico', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    ordemServico.id := strToIntZero(Req.Query['codigo']);
    ordemServico.finalidade := Req.Query['finalidade'];
    ordemServico.situacao := Req.Query['situacao'];
    ordemServico.empresa.id := strToIntZero(Req.Query['empresaCodigo']);
    ordemServico.cliente.id := strToIntZero(Req.Query['clienteCodigo']);
    ordemServico.endereco.id := strToIntZero(Req.Query['enderecoCodigo']);
    ordemServico.transportador.id := strToIntZero(Req.Query['transportadoraCodigo']);
    ordemServico.tipoFrete := Req.Query['tipoFrete'];
    ordemServico.detalhamento := Req.Query['detalhamento'];
    ordemServico.observacao := Req.Query['observacao'];
    ordemServico.dataEntrega := StrToDateDef(Req.Query['dataEntrega'], StrToDate('31/12/1989'));
    ordemServico.dataEntregaFinal := StrToDateDef(Req.Query['dataEntregaFinal'], StrToDate('31/12/1989'));
    ordemServico.dataOrdem := StrToDateDef(Req.Query['dataOrdem'], StrToDate('31/12/1989'));
    ordemServico.dataOrdemFinal := StrToDateDef(Req.Query['dataOrdemFinal'], StrToDate('31/12/1989'));
    ordemServico.status := Req.Query['status'];
    ordemServico.limite := strToIntZero(Req.Query['limite']);
    ordemServico.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao recuperar informa��es da requisi��o!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (ordemServico.status = '') then
  begin
    ordemServico.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (ordemServico.id > 0) or
       (ordemServico.finalidade <> '') or
       (ordemServico.situacao <> '') or
       (ordemServico.tipoFrete <> '') or
       (ordemServico.detalhamento <> '') or
       (ordemServico.observacao <> '') or
       (ordemServico.dataEntrega > StrToDate('31/12/1989')) or
       (ordemServico.dataEntregaFinal > StrToDate('31/12/1989')) or
       (ordemServico.dataOrdem > StrToDate('31/12/1989')) or
       (ordemServico.dataOrdemFinal > StrToDate('31/12/1989')) or
       (ordemServico.empresa.id > 0) or
       (ordemServico.cliente.id > 0) or
       (ordemServico.endereco.id > 0) or
       (ordemServico.transportador.id > 0)  then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    ordensServico := ordemServico.consultar();
    quantidade := Length(ordensServico);

    resposta.AddPair('tipo', 'consulta Ordens Servico');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(ordemServico.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(ordemServico.limite));
    resposta.AddPair('offset', TJSONNumber.Create(ordemServico.offset));

    if not Assigned(ordensServico) then
    begin
      if (Length(ordensServico) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os cidades!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarOrdemServico(ordensServico[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      ordensServico[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('ORDEMSERVICO003', 'Erro n�o tratado ao listar todos as ordens de servi�o!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  ordemServico.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarOrdemServico(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  ordemServicoConsultado: TOrdemServico;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOrdemServico(Req, Res, 'cadastrarOrdemServico', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];

    ordemServico.empresa.id := body.GetValue<Integer>('empresaCodigo', 0);
    ordemServico.cliente.id := body.GetValue<Integer>('clienteCodigo', 0);
    ordemServico.endereco.id := body.GetValue<Integer>('enderecoCodigo', 0);
    ordemServico.transportador.id := body.GetValue<Integer>('transportadoraCodigo', 0);
    ordemServico.finalidade := body.GetValue<string>('finalidade', '');
    ordemServico.tipoFrete := body.GetValue<string>('tipoFrete', '');
    ordemServico.detalhamento := body.GetValue<string>('detalhamento', '');
    ordemServico.observacao := body.GetValue<string>('observacao', '');
    ordemServico.dataEntrega := body.GetValue<TDate>('dataEntrega', StrToDate('31/12/1989'));
    ordemServico.dataOrdem := body.GetValue<TDate>('dataOrdem', StrToDate('31/12/1989'));
    ordemServico.desconto:= body.GetValue<Double>('desconto', 0);
    ordemServico.situacao := 'OR�AMENTO';
    ordemServico.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisi��o: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  // continuar daqui

//  if (continuar) and (verificarToken(res, resposta)) then
//  try
//    erros := TStringList.Create;
//    arrayResposta := TJSONArray.Create;
//
//    if (ordemServico.nome = '') then
//    begin
//      erros.Add('O Nome da cidade deve ser informado!');
//    end
//    else if (Length(Trim(ordemServico.nome)) <= 2) then
//    begin
//      erros.Add('O nome da cidade deve conter no minimo 3 caracteres validos!');
//    end
//    else if (Length(Trim(ordemServico.nome)) > 150) then
//    begin
//      erros.Add('O nome da cidade deve conter no maximo 150 caracteres validos!');
//    end;
//
//    if (Trim(ordemServico.codigoIbge) = '') then
//    begin
//      erros.Add('O codigo do IBGE deve ser informado!');
//    end
//    else if (Length(Trim(soNumeros(ordemServico.codigoIbge))) <> 7) then
//    begin
//      erros.Add('O codigo do IBGE deve conter 7 caracteres numericos validos!');
//    end;
//
//    if not (ordemServico.estado.id > 0) then
//    begin
//      erros.Add('O Estado da cidade deve ser informado!');
//    end;
//
//    if (erros.Text = '') then
//    begin
//      ordemServicoConsultado := ordemServico.existeRegistro();
//
//      if (Assigned(ordemServicoConsultado)) then
//      begin
//        erros.Add('J� existe um cidade [' + IntToStrSenaoZero(ordemServicoConsultado.id) +
//                  ' - ' + ordemServicoConsultado.nome +
//                  ' - ' + ordemServicoConsultado.status + '], cadastrada com esse codigo IBGE ou com esse nome!');
//        ordemServicoConsultado.Destroy;
//      end
//      else
//      begin
//        ordemServicoConsultado := TordemServico.Create;
//        ordemServicoConsultado.estado.Destroy;
//        ordemServicoConsultado.estado := ordemServico.estado.consultarChave();
//
//        if not (Assigned(ordemServicoConsultado.estado)) then
//        begin
//          erros.Add('Nenhum Estado encontrado com o codigo [' + IntToStrSenaoZero(ordemServico.estado.id) + ']!');
//        end;
//
//        ordemServicoConsultado.Destroy;
//      end;
//    end;
//
//    if (erros.Text <> '') then
//    begin
//      for i := 0 to erros.Count - 1 do
//      begin
//        arrayResposta.Add(UFuncao.JsonErro('ORDEMSERVICO006',  erros[i]));
//      end;
//
//      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
//      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
//    end
//    else
//    begin
//      FreeAndNil(arrayResposta);
//      ordemServicoConsultado := ordemServico.cadastrarOrdemServico();
//
//      if Assigned(ordemServicoConsultado) then
//      begin
//        resposta.AddPair('tipo', 'Cadastro de cidade');
//        resposta.AddPair('registrosAfetados', TJSONNumber.Create(ordemServico.registrosAfetados));
//        montarOrdemServico(ordemServicoConsultado, resposta);
//        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
//
//        ordemServicoConsultado.Destroy;
//      end
//      else
//      begin
//        mensagem := 'Erro n�o tratado ao cadastrar uma cidade!';
//        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO007', mensagem))));
//        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
//      end;
//    end;
//
//    FreeAndNil(erros);
//  except
//    on E: Exception do
//    begin
//      mensagem := 'Erro n�o tratado ao cadastrar uma cidade!';
//      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO007', mensagem))));
//      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
//    end;
//  end;

  ordemServico.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarOrdemServico(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  ordemServicoConsultado: TOrdemServico;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOrdemServico(Req, Res, 'alterarOrdemServico', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
//    ordemServico.nome := body.GetValue<string>('nomecidade', '');
//    ordemServico.estado.id := body.GetValue<Integer>('codigoEstado', 0);
//    ordemServico.codigoIbge := body.GetValue<string>('codigoIBGE', '');
//    ordemServico.status := body.GetValue<string>('status', 'A');
//    ordemServico.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisi��o: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

//  if (continuar) and (verificarToken(res, resposta)) then
//  try
//    erros := TStringList.Create;
//    arrayResposta := TJSONArray.Create;
//
//    if not (ordemServico.id > 0) then
//    begin
//      erros.Add('O Codigo da cidade deve ser informado, ou deve ser um numero inteiro valido!');
//    end;
//
//    if (ordemServico.nome = '') then
//    begin
//      erros.Add('O Nome da cidade deve ser informado!');
//    end
//    else if (Length(Trim(ordemServico.nome)) <= 2) then
//    begin
//      erros.Add('O nome da cidade deve conter no minimo 3 caracteres validos!');
//    end
//    else if (Length(Trim(ordemServico.nome)) > 150) then
//    begin
//      erros.Add('O nome da cidade deve conter no maximo 150 caracteres validos!');
//    end;
//
//    if (Trim(ordemServico.codigoIbge) = '') then
//    begin
//      erros.Add('O codigo do IBGE deve ser informado!');
//    end
//    else if (Length(Trim(soNumeros(ordemServico.codigoIbge))) <> 7) then
//    begin
//      erros.Add('O codigo do IBGE deve conter 7 caracteres numericos validos!');
//    end;
//
//    if not (ordemServico.estado.id > 0) then
//    begin
//      erros.Add('O Estado do cidade deve ser informado!');
//    end;
//
//    if (ordemServico.status <> 'A') and (ordemServico.status <> 'I') then
//    begin
//      erros.Add('O Status da cidade informado � invalido!');
//    end;
//
//    if (erros.Text = '') then
//    begin
//      ordemServicoConsultado := ordemServico.consultarChave();
//
//      if not (Assigned(ordemServicoConsultado)) then
//      begin
//        erros.Add('Nenhuma cidade encontrado com o codigo [' + IntToStrSenaoZero(ordemServico.id) + ']!');
//      end
//      else
//      begin
//        ordemServicoConsultado.Destroy;
//        ordemServicoConsultado := ordemServico.existeRegistro();
//
//        if (Assigned(ordemServicoConsultado)) then
//        begin
//          erros.Add('J� existe uma cidade [' + IntToStrSenaoZero(ordemServicoConsultado.id) +
//                  ' - ' + ordemServicoConsultado.nome +
//                  ' - ' + ordemServicoConsultado.status + '], cadastrada com esse codigo IBGE ou com esse nome!');
//          ordemServicoConsultado.Destroy;
//        end;
//      end;
//
//      ordemServicoConsultado := TordemServico.Create;
//      ordemServicoConsultado.estado.Destroy;
//      ordemServicoConsultado.estado := ordemServico.estado.consultarChave();
//
//      if not (Assigned(ordemServicoConsultado.estado)) then
//      begin
//        erros.Add('Nenhum Estado encontrado com o codigo [' + IntToStrSenaoZero(ordemServico.estado.id) + ']!');
//      end;
//
//      ordemServicoConsultado.Destroy;
//    end;
//
//    if (erros.Text <> '') then
//    begin
//      for i := 0 to erros.Count - 1 do
//      begin
//        arrayResposta.Add(UFuncao.JsonErro('ORDEMSERVICO013',  erros[i]));
//      end;
//
//      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
//      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
//    end
//    else
//    begin
//      FreeAndNil(arrayResposta);
//      ordemServicoConsultado := ordemServico.alterarOrdemServico();
//
//      if Assigned(ordemServicoConsultado) then
//      begin
//        resposta.AddPair('tipo', 'Altera��o de cidade');
//        resposta.AddPair('registrosAfetados', TJSONNumber.Create(ordemServico.registrosAfetados));
//        montarOrdemServico(ordemServicoConsultado, resposta);
//        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
//
//        ordemServicoConsultado.Destroy;
//      end
//      else
//      begin
//        mensagem := 'Erro n�o tratado ao alterar uma cidade!';
//        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO014', mensagem))));
//        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
//      end;
//    end;
//
//    FreeAndNil(erros);
//  except
//    on E: Exception do
//    begin
//      mensagem := 'Erro n�o tratado ao alterar uma cidade!';
//      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ORDEMSERVICO014', mensagem))));
//      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
//    end;
//  end;

  ordemServico.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/ordemServico', buscarOrdensServico);
  THorse.Post('/ordemServico', cadastrarOrdemServico);
  THorse.Put('/ordemServico/:id', alterarOrdemServico);
end;

end.
