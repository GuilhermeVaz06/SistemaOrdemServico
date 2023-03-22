unit Controller.OrdemServico.Item;

interface

uses Horse, System.SysUtils, Model.OrdemServico.Item, System.JSON, System.Classes,
     Principal, UFuncao;

var
  item: TItem;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  item.limpar;
  token := '';
end;

procedure montarContato(contatoItem: TItem; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(contatoItem.id));
  resposta.AddPair('ordem',TJSONNumber.Create(contatoItem.id));
  resposta.AddPair('descricao',TJSONNumber.Create(contatoItem.ordemServico.id));
  resposta.AddPair('quantidade',TJSONNumber.Create(contatoItem.quantidade));
  resposta.AddPair('valorUnitario',TJSONNumber.Create(contatoItem.valorUnitario));
  resposta.AddPair('valorTotal',TJSONNumber.Create(contatoItem.valorTotal));
  resposta.AddPair('desconto',TJSONNumber.Create(contatoItem.desconto));
  resposta.AddPair('valorDesconto',TJSONNumber.Create(contatoItem.valorDesconto));
  resposta.AddPair('valorFinal',TJSONNumber.Create(contatoItem.valorFinal));
  resposta.AddPair('cadastradoPor',contatoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',contatoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(contatoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(contatoItem.ultimaAlteracao));
  resposta.AddPair('status',contatoItem.status);
end;

function gerarLogContato(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := item.GerarLog('Item',
                                procedimento,
                                imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    item := TItem.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Item');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    item.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Item');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (item.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarItens(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  itens: TArray<TItem>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'buscarItens', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    item.id := strToIntZero(Req.Query['codigo']);
    item.status := Req.Query['status'];
    item.limite := strToIntZero(Req.Query['limite']);
    item.offset := strToIntZero(Req.Query['offset']);
    item.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (item.ordemServico.id > 0) then
  begin
    mensagem := 'O codigo da ordem deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (item.status = '') then
  begin
    item.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (item.ordemServico.id > 0) or
       (item.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    itens := item.consultar();
    quantidade := Length(itens);

    resposta.AddPair('tipo', 'consulta Itens');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(item.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(item.limite));
    resposta.AddPair('offset', TJSONNumber.Create(item.offset));

    if not Assigned(itens) then
    begin
      if (Length(itens) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Itens!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarContato(itens[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      itens[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('ITEM003', 'Erro não tratado ao listar todos os Itens!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  item.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  itemConsultado: TItem;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'cadastrarItem', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    item.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    item.descricao := body.GetValue<string>('ordem', '');
    item.quantidade := body.GetValue<Double>('quantidade', 0);
    item.valorUnitario := body.GetValue<Double>('valorUnitario', 0);
    item.desconto := body.GetValue<Double>('desconto', 0);
    item.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (item.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (item.descricao = '') then
    begin
      erros.Add('A descrição do item deve ser informada!');
    end
    else if (Length(item.descricao) <= 3) then
    begin
      erros.Add('O descrição deve conter no minimo 4 caracteres validos!');
    end
    else if (Length(item.descricao) > 250) then
    begin
      erros.Add('O descrição deve conter no maximo 250 caracteres validos!');
    end;

    if not (item.quantidade > 0) then
    begin
      erros.Add('A quantidade deve ser informada!');
    end;

    if not (item.valorUnitario > 0) then
    begin
      erros.Add('O valor unitario deve ser informado!');
    end;

    if (erros.Text = '') then
    begin
      itemConsultado := item.existeRegistro();

      if (Assigned(itemConsultado)) then
      begin
        erros.Add('Já existe um item [' + IntToStrSenaoZero(itemConsultado.id) +
                  ' - ' + itemConsultado.descricao +
                  ' - ' + itemConsultado.status + '] com essa mesma descrição para essa ordem!');
        itemConsultado.Destroy;
      end
      else
      begin
        itemConsultado := TItem.Create;
        itemConsultado.ordemServico.Destroy;
        itemConsultado.ordemServico := item.ordemServico.consultarChave();

        if not (Assigned(itemConsultado.ordemServico)) then
        begin
          erros.Add('Nenhuma ordem com o codigo [' + IntToStrSenaoZero(item.ordemServico.id) + ']!');
        end
        else
        begin
          itemConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ITEM006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      itemConsultado := item.cadastrarItem();

      if Assigned(itemConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Item');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(item.registrosAfetados));
        montarContato(itemConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        itemConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Item!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Item!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  item.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  itemConsultado: TItem;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'alterarItem', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    item.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    item.descricao := body.GetValue<string>('ordem', '');
    item.quantidade := body.GetValue<Double>('quantidade', 0);
    item.valorUnitario := body.GetValue<Double>('valorUnitario', 0);
    item.desconto := body.GetValue<Double>('desconto', 0);
    item.status := body.GetValue<string>('status', 'A');
    item.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (item.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (item.descricao = '') then
    begin
      erros.Add('A descrição do item deve ser informada!');
    end
    else if (Length(item.descricao) <= 3) then
    begin
      erros.Add('O descrição deve conter no minimo 4 caracteres validos!');
    end
    else if (Length(item.descricao) > 250) then
    begin
      erros.Add('O descrição deve conter no maximo 250 caracteres validos!');
    end;

    if not (item.quantidade > 0) then
    begin
      erros.Add('A quantidade deve ser informada!');
    end;

    if not (item.valorUnitario > 0) then
    begin
      erros.Add('O valor unitario deve ser informado!');
    end;

    if (item.status <> 'A') and (item.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      itemConsultado := item.consultarChave();

      if not (Assigned(itemConsultado)) then
      begin
        erros.Add('Nenhum item encontrado com o codigo [' + IntToStrSenaoZero(item.id) + '] para essa ordem!');
      end
      else
      begin
        itemConsultado.Destroy;
        itemConsultado := item.existeRegistro();

        if (Assigned(itemConsultado)) then
        begin
          erros.Add('Já existe um item [' + IntToStrSenaoZero(itemConsultado.id) +
                  ' - ' + itemConsultado.descricao +
                  ' - ' + itemConsultado.status + '] com essa mesma descrição para essa ordem!');
          itemConsultado.Destroy;
        end;
      end;

      itemConsultado := TItem.Create;
      itemConsultado.ordemServico.Destroy;
      itemConsultado.ordemServico := item.ordemServico.consultarChave();

      if not (Assigned(itemConsultado.ordemServico)) then
      begin
        erros.Add('Nenhuma ordem encontrada com o codigo [' + IntToStrSenaoZero(itemConsultado.ordemServico.id) + ']!');
      end
      else
      begin
        itemConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ITEM013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      itemConsultado := item.alterarItem();

      if Assigned(itemConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Item');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(item.registrosAfetados));
        montarContato(itemConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        itemConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Item!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Item!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  item.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarItem(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  itemConsultado: TItem;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'inativarItem', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    item.id := strToIntZero(Req.Params['id']);
    item.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (item.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (item.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      itemConsultado := item.consultarChave();

      if not (Assigned(itemConsultado)) then
      begin
        erros.Add('Nenhum item encontrado com o codigo [' + IntToStrSenaoZero(item.id) + '] para essa ordem!');
      end
      else
      begin
        itemConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ITEM016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      itemConsultado := item.inativarItem();

      if Assigned(itemConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Item');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(item.registrosAfetados));
        montarContato(itemConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        itemConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Item!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Item!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ITEM017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  item.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/ordemServicoItem/:ordem', buscarItens);
  THorse.Post('/ordemServicoItem', cadastrarItem);
  THorse.Put('/ordemServicoItem/:ordem/:id', alterarItem);
  THorse.Delete('/ordemServicoItem/:ordem/:id', inativarItem);
end;

end.
