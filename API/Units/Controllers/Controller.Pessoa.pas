unit Controller.Pessoa;

interface

uses Horse, System.SysUtils, Model.Pessoa, System.JSON, System.Classes,
     Principal, UFuncao;

var
  pessoa: TPessoa;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  pessoa.limpar;
  token := '';
end;

procedure montarPessoa(pessoaItem: TPessoa; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo', TJSONNumber.Create(pessoaItem.id));
  resposta.AddPair('codigoTipoDocumento', TJSONNumber.Create(pessoaItem.tipoDocumento.id));
  resposta.AddPair('tipoDocumento', pessoaItem.tipoDocumento.descricao);
  resposta.AddPair('qtdeCaracteres', TJSONNumber.Create(pessoaItem.tipoDocumento.qtdeCaracteres));
  resposta.AddPair('mascaraCaracteres', pessoaItem.tipoDocumento.mascara);
  resposta.AddPair('documento', pessoaItem.documento);
  resposta.AddPair('razaoSocial', pessoaItem.razaoSocial);
  resposta.AddPair('nomeFantasia', pessoaItem.nomeFantasia);
  resposta.AddPair('telefone', pessoaItem.telefone);
  resposta.AddPair('email', pessoaItem.email);
  resposta.AddPair('senha', pessoaItem.senha);
  resposta.AddPair('observacao', pessoaItem.observacao);
  resposta.AddPair('cadastradoPor', pessoaItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor', pessoaItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro', DateTimeToStr(pessoaItem.dataCadastro));
  resposta.AddPair('dataAlteracao', DateTimeToStr(pessoaItem.ultimaAlteracao));
  resposta.AddPair('status', pessoaItem.status);
end;

function gerarLogPessoa(Req: THorseRequest; Res: THorseResponse; procedimento: string): Integer;
var
  resposta: TJSONObject;
  mensagem: string;
begin
  resposta := TJSONObject.Create;

  try
    Result := pessoa.GerarLog('Pessoa',
                             procedimento,
                             imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;

  FreeAndNil(resposta);
end;

procedure destruirConexao;
begin
  try
    pessoa.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Pessoa');
    end;
  end;
end;

procedure criarConexao;
begin
  try
    pessoa := Tpessoa.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Pessoa');
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
    if not (pessoa.verificarToken(token)) then
    begin
      mensagem := 'O token informado � invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;

  FreeAndNil(resposta);
end;

procedure buscarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  pessoas: TArray<TPessoa>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPessoa(Req, Res, 'buscarPessoa');

  if (continuar) then
  try
    token := Req.Headers['token'];
    pessoa.id := strToIntZero(Req.Query['codigo']);
    pessoa.tipoDocumento.id := strToIntZero(Req.Query['codigoTipoDocumento']);
    pessoa.tipoDocumento.descricao := Req.Query['tipoDocumento'];
    pessoa.tipoPessoa.id := 0; // fazer overload de cada funcao
    pessoa.documento := Req.Query['documento'];
    pessoa.razaoSocial := Req.Query['razaoSocial'];
    pessoa.nomeFantasia := Req.Query['nomeFantasia'];
    pessoa.telefone := Req.Query['telefone'];
    pessoa.email := Req.Query['email'];
    pessoa.senha := Req.Query['senha'];
    pessoa.observacao := Req.Query['observacao'];
    pessoa.status := Req.Query['status'];
    pessoa.limite := strToIntZero(Req.Query['limite']);
    pessoa.offset := strToIntZero(Req.Query['offset']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao recuperar informa��es da requisi��o!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (pessoa.status = '') then
  begin
    pessoa.status := 'A';
  end;

  if (continuar) and (verificarToken(res)) then
  try
    if (pessoa.id > 0) or
       (pessoa.tipoDocumento.descricao <> '') or
       (pessoa.tipoDocumento.id > 0) or
       (pessoa.documento <> '') or
       (pessoa.razaoSocial <> '') or
       (pessoa.nomeFantasia <> '') or
       (pessoa.telefone <> '') or
       (pessoa.email <> '') or
       (pessoa.senha <> '') or
       (pessoa.observacao <> '') then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    pessoas := pessoa.consultar();
    quantidade := Length(pessoas);

    resposta.AddPair('tipo', 'consulta Pessoas');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(pessoa.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(pessoa.limite));
    resposta.AddPair('offset', TJSONNumber.Create(pessoa.offset));

    if not Assigned(pessoas) then
    begin
      if (Length(pessoas) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar as Pessoas!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarPessoa(pessoas[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      pessoas[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('PESSOA003', 'Erro n�o tratado ao listar todas as Pessoas!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  pessoaConsultado: TPessoa;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPessoa(Req, Res, 'cadastrarPessoa');

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    pessoa.tipoPessoa.id := 0;
    pessoa.tipoDocumento.id := body.GetValue<integer>('codigoTipoDocumento', 0);
    pessoa.documento := body.GetValue<string>('documento', '');
    pessoa.razaoSocial := body.GetValue<string>('razaoSocial', '');
    pessoa.nomeFantasia := body.GetValue<string>('nomeFantasia', '');
    pessoa.telefone := body.GetValue<string>('telefone', '');
    pessoa.email := body.GetValue<string>('email', '');
    pessoa.senha := body.GetValue<string>('senha', '');
    pessoa.observacao := body.GetValue<string>('observacao', '');
    pessoa.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisi��o: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (pessoa.razaoSocial = '') then
    begin
      erros.Add('A Raz�o Social deve ser informada!');
    end
    else if (Length(Trim(pessoa.razaoSocial)) <= 2) then
    begin
      erros.Add('A Raz�o Social deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(pessoa.razaoSocial)) > 150) then
    begin
      erros.Add('A Raz�o Social deve conter no maximo 150 caracteres validos!');
    end;

    if (pessoa.nomeFantasia = '') then
    begin
      erros.Add('O Nome fantasia deve ser informado!');
    end
    else if (Length(Trim(pessoa.nomeFantasia)) <= 2) then
    begin
      erros.Add('O Nome fantasia deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(pessoa.nomeFantasia)) > 150) then
    begin
      erros.Add('O Nome fantasia deve conter no maximo 150 caracteres validos!');
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.existeRegistro();

      if (Assigned(pessoaConsultado)) then
      begin
        erros.Add('J� existe um Pessoa [' + IntToStrSenaoZero(pessoaConsultado.id) +
                  ' - ' + pessoaConsultado.razaoSocial + '], cadastrado com esse nome fantasia e com esse documento!');
        pessoaConsultado.Destroy;
      end
      else
      begin
        pessoaConsultado := TPessoa.Create;
        pessoaConsultado.tipoDocumento.Destroy;
        pessoaConsultado.tipoDocumento := pessoa.tipoDocumento.consultarChave();

        if not (Assigned(pessoaConsultado.tipoDocumento)) then
        begin
          erros.Add('Nenhum Tipo de Documento encontrado com o codigo [' + IntToStrSenaoZero(pessoaConsultado.tipoDocumento.id) + ']!');
        end
        else if (Length(Trim(soNumeros(pessoa.documento))) <> pessoaConsultado.tipoDocumento.qtdeCaracteres) then
        begin
          erros.Add('O Numero do documento � invalido, deve conter ' + IntToStrSenaoZero(pessoaConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
        end;

        pessoaConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PESSOA006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      pessoaConsultado := pessoa.cadastrarPessoa();

      if Assigned(pessoaConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Pessoa');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        montarPessoa(pessoaConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        pessoaConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro n�o tratado ao cadastrar uma Pessoa!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao cadastrar uma Pessoa!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  pessoaConsultado: TPessoa;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPessoa(Req, Res, 'alterarPessoa');

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    pessoa.tipoPessoa.id := 0;
    pessoa.tipoDocumento.id := body.GetValue<integer>('codigoTipoDocumento', 0);
    pessoa.documento := body.GetValue<string>('documento', '');
    pessoa.razaoSocial := body.GetValue<string>('razaoSocial', '');
    pessoa.nomeFantasia := body.GetValue<string>('nomeFantasia', '');
    pessoa.telefone := body.GetValue<string>('telefone', '');
    pessoa.email := body.GetValue<string>('email', '');
    pessoa.senha := body.GetValue<string>('senha', '');
    pessoa.observacao := body.GetValue<string>('observacao', '');
    pessoa.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisi��o: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pessoa.id > 0) then
    begin
      erros.Add('O Codigo da Pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (pessoa.razaoSocial = '') then
    begin
      erros.Add('A Raz�o Social deve ser informada!');
    end
    else if (Length(Trim(pessoa.razaoSocial)) <= 2) then
    begin
      erros.Add('A Raz�o Social deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(pessoa.razaoSocial)) > 150) then
    begin
      erros.Add('A Raz�o Social deve conter no maximo 150 caracteres validos!');
    end;

    if (pessoa.nomeFantasia = '') then
    begin
      erros.Add('O Nome fantasia deve ser informado!');
    end
    else if (Length(Trim(pessoa.nomeFantasia)) <= 2) then
    begin
      erros.Add('O Nome fantasia deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(pessoa.nomeFantasia)) > 150) then
    begin
      erros.Add('O Nome fantasia deve conter no maximo 150 caracteres validos!');
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.consultarChave();

      if not (Assigned(pessoaConsultado)) then
      begin
        erros.Add('Nenhuma Pessoa encontrado com o codigo [' + IntToStrSenaoZero(pessoa.id) + ']!');
      end
      else
      begin
        pessoaConsultado.Destroy;
        pessoaConsultado := pessoa.existeRegistro();

        if (Assigned(pessoaConsultado)) then
        begin
          erros.Add('J� existe um Pessoa [' + IntToStrSenaoZero(pessoaConsultado.id) +
                    ' - ' + pessoaConsultado.razaoSocial + '], cadastrado com esse nome fantasia e com esse documento!');
          pessoaConsultado.Destroy;
        end
        else
        begin
           pessoaConsultado := TPessoa.Create;
          pessoaConsultado.tipoDocumento.Destroy;
          pessoaConsultado.tipoDocumento := pessoa.tipoDocumento.consultarChave();

          if not (Assigned(pessoaConsultado.tipoDocumento)) then
          begin
            erros.Add('Nenhum Tipo de Documento encontrado com o codigo [' + IntToStrSenaoZero(pessoaConsultado.tipoDocumento.id) + ']!');
          end
          else if (Length(Trim(soNumeros(pessoa.documento))) <> pessoaConsultado.tipoDocumento.qtdeCaracteres) then
          begin
            erros.Add('O Numero do documento � invalido, deve conter ' + IntToStrSenaoZero(pessoaConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
          end;

          pessoaConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PESSOA013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      pessoaConsultado := pessoa.alterarPessoa();

      if Assigned(pessoaConsultado) then
      begin
        resposta.AddPair('tipo', 'Altera��o de Pessoa');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        montarPessoa(pessoaConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        pessoaConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro n�o tratado ao alterar uma Pessoa!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao alterar uma Pessoa!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  pessoaConsultado: TPessoa;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPessoa(Req, Res, 'inativarPessoa');

  if (continuar) then
  try
    token := Req.Headers['token'];
    pessoa.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisi��o: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(JsonErro('PESSOA015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pessoa.id > 0) then
    begin
      erros.Add('O Codigo da Pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.consultarChave();

      if not (Assigned(pessoaConsultado)) then
      begin
        erros.Add('Nenhuma Pessoa encontrado com o codigo [' + IntToStrSenaoZero(pessoa.id) + ']!');
      end
      else
      begin
        pessoaConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('PESSOA016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      pessoaConsultado := pessoa.inativarPessoa();

      if Assigned(pessoaConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclus�o de Pessoa');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        montarPessoa(pessoaConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        pessoaConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro n�o tratado ao inativar uma Pessoa!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro n�o tratado ao inativar uma Pessoa!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('PESSOA017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/pessoa', buscarPessoa);
  THorse.Post('/pessoa', cadastrarPessoa);
  THorse.Put('/pessoa/:id', alterarPessoa);
  THorse.Delete('/pessoa/:id', inativarPessoa);
end;

end.
