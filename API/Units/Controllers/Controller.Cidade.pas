unit Controller.Cidade;

interface

uses Horse, System.SysUtils, Model.Cidade, System.JSON, System.Classes,
     Principal, UFuncao;

var
  cidade: TCidade;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  cidade.limpar;
  token := '';
end;

procedure montarCidade(cidadeItem: TCidade; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(cidadeItem.id));
  resposta.AddPair('codigoEstado', TJSONNumber.Create(cidadeItem.estado.id));
  resposta.AddPair('nomeEstado',cidadeItem.estado.nome);
  resposta.AddPair('codigoPais', TJSONNumber.Create(cidadeItem.estado.pais.id));
  resposta.AddPair('nomePais',cidadeItem.estado.pais.nome);
  resposta.AddPair('codigoIbge',cidadeItem.codigoIbge);
  resposta.AddPair('nome',cidadeItem.nome);
  resposta.AddPair('cadastradoPor',cidadeItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',cidadeItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(cidadeItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(cidadeItem.ultimaAlteracao));
  resposta.AddPair('status',cidadeItem.status);
end;

procedure criarConexao;
begin
  try
    cidade := TCidade.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Cidade');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    cidade.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Cidade');
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
    if not (cidade.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;

  FreeAndNil(resposta);
end;

procedure buscarCidades(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  cidades: TArray<TCidade>;
  filtrado: Boolean;
  mensagem: string;
begin
  continuar := True;
  resposta := TJSONObject.Create;

  try
    token := Req.Headers['token'];
    cidade.id := strToIntZero(Req.Query['codigo']);
    cidade.nome := Req.Query['nomecidade'];
    cidade.estado.nome := Req.Query['nomeEstado'];
    cidade.estado.id := strToIntZero(Req.Query['codigoEstado']);
    cidade.estado.pais.nome := Req.Query['nomePais'];
    cidade.estado.pais.id := strToIntZero(Req.Query['codigoPais']);
    cidade.codigoIbge := Req.Query['codigoIBGE'];
    cidade.status := Req.Query['status'];
    cidade.limite := strToIntZero(Req.Query['limite']);
    cidade.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (cidade.status = '') then
  begin
    cidade.status := 'A';
  end;

  if (continuar) and (verificarToken(res)) then
  try
    if (cidade.nome <> '') or
       (cidade.codigoIbge <> '') or
       (cidade.estado.nome <> '') or
       (cidade.estado.id > 0) or
       (cidade.estado.pais.nome <> '') or
       (cidade.estado.pais.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    cidades := cidade.consultar();
    quantidade := Length(cidades);

    resposta.AddPair('tipo', 'consulta cidades');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(cidade.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(cidade.limite));
    resposta.AddPair('offset', TJSONNumber.Create(cidade.offset));

    if not Assigned(cidades) then
    begin
      if (Length(cidades) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os cidades!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarCidade(cidades[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      cidades[i].destroy;
    end;

  except
    on E: Exception do
    begin
      arrayResposta.Add(UFuncao.JsonErro('CIDADE003', 'Erro não tratado ao listar todos os cidades!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarCidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  cidadeConsultado: TCidade;
  i: integer;
  mensagem: string;
begin
  continuar := True;
  resposta := TJSONObject.Create;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    cidade.nome := body.GetValue<string>('nomecidade', '');
    cidade.estado.id := body.GetValue<Integer>('codigoEstado', 0);
    cidade.codigoIbge := body.GetValue<string>('codigoIBGE', '');
    cidade.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (cidade.nome = '') then
    begin
      erros.Add('O Nome da cidade deve ser informado!');
    end
    else if (Length(Trim(cidade.nome)) <= 2) then
    begin
      erros.Add('O nome da cidade deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(cidade.nome)) > 150) then
    begin
      erros.Add('O nome da cidade deve conter no maximo 150 caracteres validos!');
    end;

    if (Trim(cidade.codigoIbge) = '') then
    begin
      erros.Add('O codigo do IBGE deve ser informado!');
    end
    else if (Length(Trim(soNumeros(cidade.codigoIbge))) <> 7) then
    begin
      erros.Add('O codigo do IBGE deve conter 7 caracteres numericos validos!');
    end;

    if not (cidade.estado.id > 0) then
    begin
      erros.Add('O Estado da cidade deve ser informado!');
    end;

    if (erros.Text = '') then
    begin
      cidadeConsultado := cidade.existeRegistro();

      if (Assigned(cidadeConsultado)) then
      begin
        erros.Add('Já existe um cidade [' + IntToStrSenaoZero(cidadeConsultado.id) +
                  ' - ' + cidadeConsultado.nome + '], cadastrada com esse codigo IBGE ou com esse nome!');
        cidadeConsultado.Destroy;
      end
      else
      begin
        cidadeConsultado := TCidade.Create;
        cidadeConsultado.estado.Destroy;
        cidadeConsultado.estado := cidade.estado.consultarChave();

        if not (Assigned(cidadeConsultado.estado)) then
        begin
          erros.Add('Nenhum Estado encontrado com o codigo [' + IntToStrSenaoZero(cidade.estado.id) + ']!');
        end;

        cidadeConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CIDADE006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      cidadeConsultado := cidade.cadastrarcidade();

      if Assigned(cidadeConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de cidade');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(cidade.registrosAfetados));
        montarCidade(cidadeConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        cidadeConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar uma cidade!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar uma cidade!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarCidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  cidadeConsultado: TCidade;
  i: integer;
  mensagem: string;
begin
  continuar := True;
  resposta := TJSONObject.Create;

  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    cidade.nome := body.GetValue<string>('nomecidade', '');
    cidade.estado.id := body.GetValue<Integer>('codigoEstado', 0);
    cidade.codigoIbge := body.GetValue<string>('codigoIBGE', '');
    cidade.status := body.GetValue<string>('status', 'A');
    cidade.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (cidade.id > 0) then
    begin
      erros.Add('O Codigo da cidade deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (cidade.nome = '') then
    begin
      erros.Add('O Nome da cidade deve ser informado!');
    end
    else if (Length(Trim(cidade.nome)) <= 2) then
    begin
      erros.Add('O nome da cidade deve conter no minimo 3 caracteres validos!');
    end
    else if (Length(Trim(cidade.nome)) > 150) then
    begin
      erros.Add('O nome da cidade deve conter no maximo 150 caracteres validos!');
    end;

    if (Trim(cidade.codigoIbge) = '') then
    begin
      erros.Add('O codigo do IBGE deve ser informado!');
    end
    else if (Length(Trim(soNumeros(cidade.codigoIbge))) <> 7) then
    begin
      erros.Add('O codigo do IBGE deve conter 7 caracteres numericos validos!');
    end;

    if not (cidade.estado.id > 0) then
    begin
      erros.Add('O Estado do cidade deve ser informado!');
    end;

    if (cidade.status <> 'A') and (cidade.status <> 'I') then
    begin
      erros.Add('O Status da cidade informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      cidadeConsultado := cidade.consultarChave();

      if not (Assigned(cidadeConsultado)) then
      begin
        erros.Add('Nenhuma cidade encontrado com o codigo [' + IntToStrSenaoZero(cidade.id) + ']!');
      end
      else
      begin
        cidadeConsultado.Destroy;
        cidadeConsultado := cidade.existeRegistro();

        if (Assigned(cidadeConsultado)) then
        begin
          erros.Add('Já existe uma cidade [' + IntToStrSenaoZero(cidadeConsultado.id) +
                  ' - ' + cidadeConsultado.nome + '], cadastrada com esse codigo IBGE ou com esse nome!');
          cidadeConsultado.Destroy;
        end;
      end;

      cidadeConsultado := TCidade.Create;
      cidadeConsultado.estado.Destroy;
      cidadeConsultado.estado := cidade.estado.consultarChave();

      if not (Assigned(cidadeConsultado.estado)) then
      begin
        erros.Add('Nenhum Estado encontrado com o codigo [' + IntToStrSenaoZero(cidade.estado.id) + ']!');
      end;

      cidadeConsultado.Destroy;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CIDADE013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      cidadeConsultado := cidade.alterarcidade();

      if Assigned(cidadeConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de cidade');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(cidade.registrosAfetados));
        montarCidade(cidadeConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        cidadeConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar uma cidade!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar uma cidade!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarCidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  cidadeConsultado: TCidade;
  i: integer;
  mensagem: string;
begin
  continuar := True;
  resposta := TJSONObject.Create;

  try
    token := Req.Headers['token'];
    cidade.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (cidade.id > 0) then
    begin
      erros.Add('O Codigo da cidade deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      cidadeConsultado := cidade.consultarChave();

      if not (Assigned(cidadeConsultado)) then
      begin
        erros.Add('Nenhuma cidade encontrado com o codigo [' + IntToStrSenaoZero(cidade.id) + ']!');
      end
      else
      begin
        cidadeConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CIDADE016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      cidadeConsultado := cidade.inativarcidade();

      if Assigned(cidadeConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de cidade');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(cidade.registrosAfetados));
        montarCidade(cidadeConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        cidadeConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar uma cidade!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar uma cidade!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CIDADE017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/cidade', buscarCidades);
  THorse.Post('/cidade', cadastrarCidade);
  THorse.Put('/cidade/:id', alterarCidade);
  THorse.Delete('/cidade/:id', inativarCidade);
end;

end.
