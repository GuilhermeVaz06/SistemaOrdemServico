unit Controller.OrdemServico.Custo;

interface

uses Horse, System.SysUtils, Model.OrdemServico.Custo, System.JSON, System.Classes,
     Principal, UFuncao;

var
  custo: TCusto;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  custo.limpar;
  token := '';
end;

procedure montarCusto(itemCusto: TCusto; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(itemCusto.id));
  resposta.AddPair('ordem',TJSONNumber.Create(itemCusto.ordemServico.id));
  resposta.AddPair('codigoGrupo', TJSONNumber.Create(itemCusto.grupo.id));
  resposta.AddPair('descricao', itemCusto.grupo.descricao);
  resposta.AddPair('subDescricao', itemCusto.grupo.subDescricao);
  resposta.AddPair('quantidade',TJSONNumber.Create(itemCusto.quantidade));
  resposta.AddPair('valorUnitario',TJSONNumber.Create(itemCusto.valorUnitario));
  resposta.AddPair('valorTotal',TJSONNumber.Create(itemCusto.valorTotal));
  resposta.AddPair('cadastradoPor',itemCusto.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',itemCusto.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(itemCusto.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(itemCusto.ultimaAlteracao));
  resposta.AddPair('status',itemCusto.status);
end;

function gerarLogCusto(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := custo.GerarLog('Custo',
                                procedimento,
                                imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    custo := TCusto.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Custo');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    custo.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Custo');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (custo.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarCustos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  custos: TArray<TCusto>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogCusto(Req, Res, 'buscarCustos', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    custo.id := strToIntZero(Req.Query['codigo']);
    custo.status := Req.Query['status'];
    custo.limite := strToIntZero(Req.Query['limite']);
    custo.offset := strToIntZero(Req.Query['offset']);
    custo.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (custo.ordemServico.id > 0) then
  begin
    mensagem := 'O codigo da ordem deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (custo.status = '') then
  begin
    custo.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (custo.ordemServico.id > 0) or
       (custo.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    custos := custo.consultar();
    quantidade := Length(custos);

    resposta.AddPair('tipo', 'consulta Custos');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(custo.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(custo.limite));
    resposta.AddPair('offset', TJSONNumber.Create(custo.offset));

    if not Assigned(custos) then
    begin
      if (Length(custos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Custos!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarCusto(custos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      custos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('CUSTO003', 'Erro não tratado ao listar todos os Custos!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  custo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarCusto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  custoConsultado: TCusto;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogCusto(Req, Res, 'cadastrarCusto', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    custo.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    custo.grupo.id := body.GetValue<Integer>('codigoGrupo', 0);
    custo.quantidade := body.GetValue<Double>('quantidade', 0);
    custo.valorUnitario := body.GetValue<Double>('valorUnitario', 0);
    custo.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (custo.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (custo.grupo.id > 0) then
    begin
      erros.Add('O grupo deve ser informado!');
    end;

    if not (custo.quantidade > 0) then
    begin
      erros.Add('A quantidade deve ser informada!');
    end;

    if not (custo.valorUnitario > 0) then
    begin
      erros.Add('O valor unitario deve ser informado!');
    end;

    if (erros.Text = '') then
    begin
      custoConsultado := custo.existeRegistro();

      if (Assigned(custoConsultado)) then
      begin
        erros.Add('Já existe um Custo [' + IntToStrSenaoZero(custoConsultado.id) +
                  ' - ' + custoConsultado.grupo.descricao +
                  ' - ' + custoConsultado.grupo.subDescricao +
                  ' - ' + custoConsultado.status + '] com essa mesma descrição para essa ordem!');
        custoConsultado.Destroy;
      end
      else
      begin
        custoConsultado := TCusto.Create;
        custoConsultado.ordemServico.Destroy;
        custoConsultado.ordemServico := custo.ordemServico.consultarChave();

        if not (Assigned(custoConsultado.ordemServico)) then
        begin
          erros.Add('Nenhuma ordem com o codigo [' + IntToStrSenaoZero(custo.ordemServico.id) + ']!');
        end
        else
        begin
          custoConsultado.grupo.Destroy;
          custoConsultado.grupo := custo.grupo.consultarChave();

          if not (Assigned(custoConsultado.grupo)) then
          begin
            erros.Add('Nenhum grupo com o codigo [' + IntToStrSenaoZero(custo.grupo.id) + ']!');
          end;

          custoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CUSTO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      custoConsultado := custo.cadastrarCusto();

      if Assigned(custoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Custo');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(custo.registrosAfetados));
        montarCusto(custoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        custoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Custo!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Custo!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  custo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarCusto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  custoConsultado: TCusto;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogCusto(Req, Res, 'alterarCusto', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    custo.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    custo.grupo.id := body.GetValue<Integer>('codigoGrupo', 0);
    custo.quantidade := body.GetValue<Double>('quantidade', 0);
    custo.valorUnitario := body.GetValue<Double>('valorUnitario', 0);
    custo.status := body.GetValue<string>('status', 'A');
    custo.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (custo.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (custo.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (custo.grupo.id > 0) then
    begin
      erros.Add('O grupo deve ser informado!');
    end;

    if not (custo.quantidade > 0) then
    begin
      erros.Add('A quantidade deve ser informada!');
    end;

    if not (custo.valorUnitario > 0) then
    begin
      erros.Add('O valor unitario deve ser informado!');
    end;

    if (custo.status <> 'A') and (custo.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      custoConsultado := custo.consultarChave();

      if not (Assigned(custoConsultado)) then
      begin
        erros.Add('Nenhum custo encontrado com o codigo [' + IntToStrSenaoZero(custo.id) + '] para essa ordem!');
      end
      else
      begin
        custoConsultado.Destroy;
        custoConsultado := custo.existeRegistro();

        if (Assigned(custoConsultado)) then
        begin
          erros.Add('Já existe um custo [' + IntToStrSenaoZero(custoConsultado.id) +
                  ' - ' + custoConsultado.grupo.descricao +
                  ' - ' + custoConsultado.grupo.subDescricao +
                  ' - ' + custoConsultado.status + '] com essa mesma descrição para essa ordem!');
          custoConsultado.Destroy;
        end;
      end;

      custoConsultado := TCusto.Create;
      custoConsultado.ordemServico.Destroy;
      custoConsultado.ordemServico := custo.ordemServico.consultarChave();

      if not (Assigned(custoConsultado.ordemServico)) then
      begin
        erros.Add('Nenhuma ordem encontrada com o codigo [' + IntToStrSenaoZero(custoConsultado.ordemServico.id) + ']!');
      end
      else
      begin
        custoConsultado.grupo.Destroy;
        custoConsultado.grupo := custo.grupo.consultarChave();

        if not (Assigned(custoConsultado.grupo)) then
        begin
          erros.Add('Nenhum grupo encontrado com o codigo [' + IntToStrSenaoZero(custoConsultado.grupo.id) + ']!');
        end;

        custoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CUSTO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      custoConsultado := custo.alterarCusto();

      if Assigned(custoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Custo');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(custo.registrosAfetados));
        montarCusto(custoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        custoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Custo!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Custo!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  custo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarCusto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  custoConsultado: TCusto;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogCusto(Req, Res, 'inativarCusto', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    custo.id := strToIntZero(Req.Params['id']);
    custo.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (custo.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (custo.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      custoConsultado := custo.consultarChave();

      if not (Assigned(custoConsultado)) then
      begin
        erros.Add('Nenhum custo encontrado com o codigo [' + IntToStrSenaoZero(custo.id) + '] para essa ordem!');
      end
      else
      begin
        custoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CUSTO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      custoConsultado := custo.inativarCusto();

      if Assigned(custoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de custo');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(custo.registrosAfetados));
        montarCusto(custoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        custoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um custo!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um custo!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CUSTO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  custo.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/ordemServicoCusto/:ordem', buscarCustos);
  THorse.Post('/ordemServicoCusto', cadastrarCusto);
  THorse.Put('/ordemServicoCusto/:ordem/:id', alterarCusto);
  THorse.Delete('/ordemServicoCusto/:ordem/:id', inativarCusto);
end;

end.
