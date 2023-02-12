unit Controller.TipoEndereco;

interface

uses Horse, System.SysUtils, Model.TipoEndereco, System.JSON, System.Classes,
     Principal, UFuncao;

var
  tipoEndereco: TTipoEndereco;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  tipoEndereco.limpar;
  token := '';
end;

procedure montarTipoEndereco(tipoEnderecoItem: TTipoEndereco; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(tipoEnderecoItem.id));
  resposta.AddPair('descricao',tipoEnderecoItem.descricao);
  resposta.AddPair('cadastradoPor',tipoEnderecoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',tipoEnderecoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(tipoEnderecoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(tipoEnderecoItem.ultimaAlteracao));
  resposta.AddPair('status',tipoEnderecoItem.status);
end;

function gerarLogTipoEndereco(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := tipoEndereco.GerarLog('TipoEndereco',
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    tipoEndereco := TTipoEndereco.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Tipo Endereço');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    tipoEndereco.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Tipo Endereço');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;
  try
    if not (tipoEndereco.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarTipoEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  tipoEnderecos: TArray<TTipoEndereco>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoEndereco(Req, Res, 'buscarTipoEndereco', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    tipoEndereco.id := strToIntZero(Req.Query['codigo']);
    tipoEndereco.descricao := Req.Query['descricao'];
    tipoEndereco.status := Req.Query['status'];
    tipoEndereco.limite := strToIntZero(Req.Query['limite']);
    tipoEndereco.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (tipoEndereco.status = '') then
  begin
    tipoEndereco.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (tipoEndereco.descricao <> '') or
       (tipoEndereco.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    tipoEnderecos := tipoEndereco.consultar();
    quantidade := Length(tipoEnderecos);

    resposta.AddPair('tipo', 'consulta Tipo Endereço');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(tipoEndereco.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(tipoEndereco.limite));
    resposta.AddPair('offset', TJSONNumber.Create(tipoEndereco.offset));

    if not Assigned(tipoEnderecos) then
    begin
      if (Length(tipoEnderecos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Tipos de Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarTipoEndereco(tipoEnderecos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      tipoEnderecos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('TIPOENDERECO003', 'Erro não tratado ao listar todos os Tipos de Endereço!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoEndereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarTipoEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  tipoEnderecoConsultado: TTipoEndereco;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoEndereco(Req, Res, 'cadastrarTipoEndereco', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    tipoEndereco.descricao := body.GetValue<string>('descricao', '');
    tipoEndereco.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (tipoEndereco.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(tipoEndereco.descricao)) <= 1) then
    begin
      erros.Add('A descrição deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(tipoEndereco.descricao)) > 150) then
    begin
      erros.Add('A descrição deve conter no maximo 150 caracteres validos!');
    end;

    if (erros.Text = '') then
    begin
      tipoEnderecoConsultado := tipoEndereco.existeRegistro();

      if (Assigned(tipoEnderecoConsultado)) then
      begin
        erros.Add('Já existe um Tipo de Endereço [' + IntToStrSenaoZero(tipoEnderecoConsultado.id) +
                  ' - ' + tipoEnderecoConsultado.descricao + '], cadastrado com essa descrição!');
        tipoEnderecoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('TIPOENDERECO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      tipoEnderecoConsultado := tipoEndereco.cadastrarTipoEndereco();

      if Assigned(tipoEnderecoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Tipo de Endereço');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(tipoEndereco.registrosAfetados));
        montarTipoEndereco(tipoEnderecoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        tipoEnderecoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Tipo de Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Tipo de Endereço!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoEndereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarTipoEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  tipoEnderecoConsultado: TTipoEndereco;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoEndereco(Req, Res, 'alterarTipoEndereco', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    tipoEndereco.descricao := body.GetValue<string>('descricao', '');
    tipoEndereco.status := body.GetValue<string>('status', 'A');
    tipoEndereco.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (tipoEndereco.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (tipoEndereco.descricao = '') then
    begin
      erros.Add('A descrição deve ser informada!');
    end
    else if (Length(Trim(tipoEndereco.descricao)) <= 2) then
    begin
      erros.Add('A descrição deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(tipoEndereco.descricao)) > 150) then
    begin
      erros.Add('A descrição deve conter no maximo 150 caracteres validos!');
    end;

    if (tipoEndereco.status <> 'A') and (tipoEndereco.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      tipoEnderecoConsultado := tipoEndereco.consultarChave();

      if not (Assigned(tipoEnderecoConsultado)) then
      begin
        erros.Add('Nenhum tipo de Endereço encontrado com o codigo [' + IntToStrSenaoZero(tipoEndereco.id) + ']!');
      end
      else
      begin
        tipoEnderecoConsultado.Destroy;
        tipoEnderecoConsultado := tipoEndereco.existeRegistro();

        if (Assigned(tipoEnderecoConsultado)) then
        begin
          erros.Add('Já existe um tipo de Endereço [' + IntToStrSenaoZero(tipoEnderecoConsultado.id) +
                  ' - ' + tipoEnderecoConsultado.descricao + '], cadastrado com essa descrição!');
          tipoEnderecoConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('TIPOENDERECO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      tipoEnderecoConsultado := tipoEndereco.alterarTipoEndereco();

      if Assigned(tipoEnderecoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Tipo de Endereço');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(tipoEndereco.registrosAfetados));
        montarTipoEndereco(tipoEnderecoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        tipoEnderecoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Tipo de Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Tipo de Endereço!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoEndereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarTipoEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  tipoEnderecoConsultado: TTipoEndereco;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogTipoEndereco(Req, Res, 'inativarTipoEndereco', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    tipoEndereco.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (tipoEndereco.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      tipoEnderecoConsultado := tipoEndereco.consultarChave();

      if not (Assigned(tipoEnderecoConsultado)) then
      begin
        erros.Add('Nenhuma tipo de Endereço encontrado com o codigo [' + IntToStrSenaoZero(tipoEndereco.id) + ']!');
      end
      else
      begin
        tipoEnderecoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('TIPOENDERECO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      tipoEnderecoConsultado := tipoEndereco.inativarTipoEndereco();

      if Assigned(tipoEnderecoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de tipo de Endereço');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(tipoEndereco.registrosAfetados));
        montarTipoEndereco(tipoEnderecoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        tipoEnderecoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um tipo de Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um tipo de Endereço!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('TIPOENDERECO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  tipoEndereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/tipoEndereco', buscarTipoEndereco);
  THorse.Post('/tipoEndereco', cadastrarTipoEndereco);
  THorse.Put('/tipoEndereco/:id', alterarTipoEndereco);
  THorse.Delete('/tipoEndereco/:id', inativarTipoEndereco);
end;

end.
