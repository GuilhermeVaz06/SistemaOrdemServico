unit Controller.OrdemServico.Produto;

interface

uses Horse, System.SysUtils, Model.OrdemServico.Produto, System.JSON, System.Classes,
     Principal, UFuncao;

var
  produto: TProduto;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  produto.limpar;
  token := '';
end;

procedure montarProduto(produtoItem: TProduto; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(produtoItem.id));
  resposta.AddPair('ordem',TJSONNumber.Create(produtoItem.ordemServico.id));
  resposta.AddPair('descricao', produtoItem.descricao);
  resposta.AddPair('unidade', produtoItem.unidade);
  resposta.AddPair('quantidade',TJSONNumber.Create(produtoItem.quantidade));
  resposta.AddPair('valorUnitario',TJSONNumber.Create(produtoItem.valorUnitario));
  resposta.AddPair('valorTotal',TJSONNumber.Create(produtoItem.valorTotal));
  resposta.AddPair('desconto',TJSONNumber.Create(produtoItem.desconto));
  resposta.AddPair('valorDesconto',TJSONNumber.Create(produtoItem.valorDesconto));
  resposta.AddPair('valorFinal',TJSONNumber.Create(produtoItem.valorFinal));
  resposta.AddPair('cadastradoPor',produtoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',produtoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(produtoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(produtoItem.ultimaAlteracao));
  resposta.AddPair('status',produtoItem.status);
end;

function gerarLogProduto(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := produto.GerarLog('Produto',
                                procedimento,
                                imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    produto := TProduto.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Produto');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    produto.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Produto');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (produto.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  produtos: TArray<TProduto>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogProduto(Req, Res, 'buscarProdutos', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    produto.id := strToIntZero(Req.Query['codigo']);
    produto.status := Req.Query['status'];
    produto.limite := strToIntZero(Req.Query['limite']);
    produto.offset := strToIntZero(Req.Query['offset']);
    produto.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (produto.ordemServico.id > 0) then
  begin
    mensagem := 'O codigo da ordem deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (produto.status = '') then
  begin
    produto.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (produto.ordemServico.id > 0) or
       (produto.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    produtos := produto.consultar();
    quantidade := Length(produtos);

    resposta.AddPair('tipo', 'consulta Produtos');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(produto.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(produto.limite));
    resposta.AddPair('offset', TJSONNumber.Create(produto.offset));

    if not Assigned(produtos) then
    begin
      if (Length(produtos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Produtos!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarProduto(produtos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      produtos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('PRODUTO003', 'Erro não tratado ao listar todos os Produtos!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  produto.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  produtoConsultado: TProduto;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogProduto(Req, Res, 'cadastrarProduto', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    produto.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    produto.descricao := body.GetValue<string>('descricao', '');
    produto.unidade := body.GetValue<string>('unidade', '');
    produto.quantidade := body.GetValue<Double>('quantidade', 0);
    produto.valorUnitario := body.GetValue<Double>('valorUnitario', 0);
    produto.desconto := body.GetValue<Double>('desconto', 0);
    produto.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (produto.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (produto.descricao = '') then
    begin
      erros.Add('A descrição do item deve ser informada!');
    end
    else if (Length(produto.descricao) <= 3) then
    begin
      erros.Add('A descrição deve conter no minimo 4 caracteres validos!');
    end
    else if (Length(produto.descricao) > 250) then
    begin
      erros.Add('A descrição deve conter no maximo 250 caracteres validos!');
    end;

    if   (produto.unidade <> 'UN')
     and (produto.unidade <> 'PC')
     and (produto.unidade <> 'KG')
     and (produto.unidade <> 'T')
     and (produto.unidade <> 'M2')
     and (produto.unidade <> 'M3')
     and (produto.unidade <> 'M')
     and (produto.unidade <> 'GR') then
    begin
      erros.Add('A Unidade informada é invalida!');
    end;

    if not (produto.quantidade > 0) then
    begin
      erros.Add('A quantidade deve ser informada!');
    end;

    if (produto.desconto > 100) then
    begin
      erros.Add('O desconto informado não pode ser maior que 100%!');
    end;

    if not (produto.valorUnitario > 0) then
    begin
      erros.Add('O valor unitario deve ser informado!');
    end;

    if (erros.Text = '') then
    begin
      produtoConsultado := produto.existeRegistro();

      if (Assigned(produtoConsultado)) then
      begin
        erros.Add('Já existe um produto [' + IntToStrSenaoZero(produtoConsultado.id) +
                  ' - ' + produtoConsultado.descricao +
                  ' - ' + produtoConsultado.status + '] com essa mesma descrição para essa ordem!');
        produtoConsultado.Destroy;
      end
      else
      begin
        produtoConsultado := TProduto.Create;
        produtoConsultado.ordemServico.Destroy;
        produtoConsultado.ordemServico := produto.ordemServico.consultarChave();

        if not (Assigned(produtoConsultado.ordemServico)) then
        begin
          erros.Add('Nenhuma ordem com o codigo [' + IntToStrSenaoZero(produto.ordemServico.id) + ']!');
        end
        else if (produtoConsultado.ordemServico.situacao = 'EXCLUIDO') or
                (produtoConsultado.ordemServico.situacao = 'CONCLUIDO') or
                (produtoConsultado.ordemServico.situacao = 'FATURADO') or
                (produtoConsultado.ordemServico.situacao = 'APROVADO') or
                (produtoConsultado.ordemServico.situacao = 'EXECUTANDO') or
                (produtoConsultado.ordemServico.situacao = 'REPROVADO') then
        begin
          erros.Add('A situação ' + produtoConsultado.ordemServico.situacao + ' não permite que seja cadastrada!');
          produtoConsultado.Destroy;
        end
        else
        begin
          produtoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PRODUTO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      produtoConsultado := produto.cadastrarProduto();

      if Assigned(produtoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Produto');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(produto.registrosAfetados));
        montarProduto(produtoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        produtoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Produto!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Produto!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  produto.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  produtoConsultado: TProduto;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogProduto(Req, Res, 'alterarProduto', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    produto.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    produto.descricao := body.GetValue<string>('descricao', '');
    produto.unidade := body.GetValue<string>('unidade', '');
    produto.quantidade := body.GetValue<Double>('quantidade', 0);
    produto.valorUnitario := body.GetValue<Double>('valorUnitario', 0);
    produto.desconto := body.GetValue<Double>('desconto', 0);
    produto.status := body.GetValue<string>('status', 'A');
    produto.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (produto.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (produto.descricao = '') then
    begin
      erros.Add('A descrição do item deve ser informada!');
    end
    else if (Length(produto.descricao) <= 3) then
    begin
      erros.Add('A descrição deve conter no minimo 4 caracteres validos!');
    end
    else if (Length(produto.descricao) > 250) then
    begin
      erros.Add('A descrição deve conter no maximo 250 caracteres validos!');
    end;

    if   (produto.unidade <> 'UN')
     and (produto.unidade <> 'PC')
     and (produto.unidade <> 'KG')
     and (produto.unidade <> 'T')
     and (produto.unidade <> 'M2')
     and (produto.unidade <> 'M3')
     and (produto.unidade <> 'M')
     and (produto.unidade <> 'GR') then
    begin
      erros.Add('A Unidade informada é invalida!');
    end;

    if not (produto.quantidade > 0) then
    begin
      erros.Add('A quantidade deve ser informada!');
    end;

    if (produto.desconto > 100) then
    begin
      erros.Add('O desconto informado não pode ser maior que 100%!');
    end;

    if not (produto.valorUnitario > 0) then
    begin
      erros.Add('O valor unitario deve ser informado!');
    end;

    if (produto.status <> 'A') and (produto.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      produtoConsultado := produto.consultarChave();

      if not (Assigned(produtoConsultado)) then
      begin
        erros.Add('Nenhum item encontrado com o codigo [' + IntToStrSenaoZero(produto.id) + '] para essa ordem!');
      end
      else
      begin
        produtoConsultado.Destroy;
        produtoConsultado := produto.existeRegistro();

        if (Assigned(produtoConsultado)) then
        begin
          erros.Add('Já existe um item [' + IntToStrSenaoZero(produtoConsultado.id) +
                  ' - ' + produtoConsultado.descricao +
                  ' - ' + produtoConsultado.status + '] com essa mesma descrição para essa ordem!');
          produtoConsultado.Destroy;
        end;
      end;

      produtoConsultado := TProduto.Create;
      produtoConsultado.ordemServico.Destroy;
      produtoConsultado.ordemServico := produto.ordemServico.consultarChave();

      if not (Assigned(produtoConsultado.ordemServico)) then
      begin
        erros.Add('Nenhuma ordem encontrada com o codigo [' + IntToStrSenaoZero(produtoConsultado.ordemServico.id) + ']!');
      end
      else if (produtoConsultado.ordemServico.situacao = 'EXCLUIDO') or
              (produtoConsultado.ordemServico.situacao = 'CONCLUIDO') or
              (produtoConsultado.ordemServico.situacao = 'FATURADO') or
              (produtoConsultado.ordemServico.situacao = 'APROVADO') or
              (produtoConsultado.ordemServico.situacao = 'EXECUTANDO') or
              (produtoConsultado.ordemServico.situacao = 'REPROVADO') then
      begin
        erros.Add('A situação ' + produtoConsultado.ordemServico.situacao + ' não permite que seja alterada!');
        produtoConsultado.Destroy;
      end
      else
      begin
        produtoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PRODUTO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      produtoConsultado := produto.alterarProduto();

      if Assigned(produtoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Produto');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(produto.registrosAfetados));
        montarProduto(produtoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        produtoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Produto!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Produto!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  produto.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  produtoConsultado: TProduto;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogProduto(Req, Res, 'inativarProduto', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    produto.id := strToIntZero(Req.Params['id']);
    produto.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (produto.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (produto.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      produtoConsultado := produto.consultarChave();

      if not (Assigned(produtoConsultado)) then
      begin
        erros.Add('Nenhum item encontrado com o codigo [' + IntToStrSenaoZero(produto.id) + '] para essa ordem!');
      end
      else
      begin
        produtoConsultado.ordemServico.Destroy;
        produtoConsultado.ordemServico := produto.ordemServico.consultarChave();

        if not (Assigned(produtoConsultado.ordemServico)) then
        begin
          erros.Add('Nenhuma ordem com o codigo [' + IntToStrSenaoZero(produto.ordemServico.id) + ']!');
        end
        else if (produtoConsultado.ordemServico.situacao = 'EXCLUIDO') or
                (produtoConsultado.ordemServico.situacao = 'CONCLUIDO') or
                (produtoConsultado.ordemServico.situacao = 'FATURADO') or
                (produtoConsultado.ordemServico.situacao = 'APROVADO') or
                (produtoConsultado.ordemServico.situacao = 'EXECUTANDO') or
                (produtoConsultado.ordemServico.situacao = 'REPROVADO') then
        begin
          erros.Add('A situação ' + produtoConsultado.ordemServico.situacao + ' não permite que seja inativado!');
          produtoConsultado.Destroy;
        end
        else
        begin
          produtoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PRODUTO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      produtoConsultado := produto.inativarProduto();

      if Assigned(produtoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Produto');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(produto.registrosAfetados));
        montarProduto(produtoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        produtoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Produto!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Produto!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PRODUTO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  produto.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/ordemServicoProduto/:ordem', buscarProdutos);
  THorse.Post('/ordemServicoProduto', cadastrarProduto);
  THorse.Put('/ordemServicoProduto/:ordem/:id', alterarProduto);
  THorse.Delete('/ordemServicoProduto/:ordem/:id', inativarProduto);
end;

end.

