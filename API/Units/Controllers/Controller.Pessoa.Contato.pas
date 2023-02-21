unit Controller.Pessoa.Contato;

interface

uses Horse, System.SysUtils, Model.Pessoa.Contato, System.JSON, System.Classes,
     Principal, UFuncao;

var
  contato: TContato;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  contato.limpar;
  token := '';
end;

procedure montarContato(contatoItem: TContato; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(contatoItem.id));
  resposta.AddPair('codigoPessoa',TJSONNumber.Create(contatoItem.pessoa.id));
  resposta.AddPair('codigoTipoDocumento',TJSONNumber.Create(contatoItem.tipoDocumento.id));
  resposta.AddPair('tipoDocumento',contatoItem.tipoDocumento.descricao);
  resposta.AddPair('mascaraCararteres',contatoItem.tipoDocumento.mascara);
  resposta.AddPair('documento',contatoItem.documento);
  resposta.AddPair('nome',contatoItem.nome);
  resposta.AddPair('dataNascimento', DateToStr(contatoItem.dataNascimento));
  resposta.AddPair('funcao',contatoItem.funcao);
  resposta.AddPair('telefone',contatoItem.telefone);
  resposta.AddPair('email',contatoItem.email);
  resposta.AddPair('observacao',contatoItem.observacao);
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
    Result := contato.GerarLog('Contato',
                                procedimento,
                                imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    contato := TContato.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Contato');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    contato.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Contato');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (contato.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarContatos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  enderecos: TArray<TContato>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'buscarContatos', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    contato.id := strToIntZero(Req.Query['codigo']);
    contato.status := Req.Query['status'];
    contato.limite := strToIntZero(Req.Query['limite']);
    contato.offset := strToIntZero(Req.Query['offset']);
    contato.pessoa.id := strToIntZero(Req.Params['pessoa']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (contato.pessoa.id > 0) then
  begin
    mensagem := 'O codigo da pessoa deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (contato.status = '') then
  begin
    contato.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (contato.pessoa.id > 0) or
       (contato.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    enderecos := contato.consultar();
    quantidade := Length(enderecos);

    resposta.AddPair('tipo', 'consulta Contatos');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(contato.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(contato.limite));
    resposta.AddPair('offset', TJSONNumber.Create(contato.offset));

    if not Assigned(enderecos) then
    begin
      if (Length(enderecos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Endereços!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarContato(enderecos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      enderecos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('CONTATO003', 'Erro não tratado ao listar todos os Contatos!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  contato.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarContato(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  contatoConsultado: TContato;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'cadastrarContato', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    contato.pessoa.id := body.GetValue<Integer>('codigoPessoa', 0);
    contato.tipoDocumento.id := body.GetValue<Integer>('codigoTipoDocumento', 0);
    contato.documento := body.GetValue<string>('documento', '');
    contato.nome := body.GetValue<string>('nome', '');
    contato.dataNascimento := StrToDate(body.GetValue<string>('dataNascimento', ''));
    contato.funcao := body.GetValue<string>('funcao', '');
    contato.telefone := body.GetValue<string>('telefone', '');
    contato.email := body.GetValue<string>('email', '');
    contato.observacao := body.GetValue<string>('observacao', '');
    contato.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (contato.tipoDocumento.id > 0) then
    begin
      contato.tipoDocumento.id := contato.tipoDocumento.buscarRegistroCadastrar('NÃO INFORMADO', '', 0);
    end;

    if not (contato.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (contato.nome = '') then
    begin
      erros.Add('O nome do contato deve ser informado!');
    end
    else if (Length(contato.nome) <= 2) then
    begin
      erros.Add('O nome deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(contato.nome) > 150) then
    begin
      erros.Add('O nome deve conter no maximo 150 caracteres validos!');
    end;

    if (contato.email <> '') then
    begin
      if (Length(contato.email) < 8) then
      begin
        erros.Add('O email deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(contato.email) > 250) then
      begin
        erros.Add('O email deve conter no maximo 250 caracteres validos!');
      end;
    end;

    if (contato.funcao <> '') then
    begin
      if (Length(contato.funcao) < 3) then
      begin
        erros.Add('A função deve conter no minimo 3 caracteres validos!');
      end
      else if (Length(contato.funcao) > 150) then
      begin
        erros.Add('A função deve conter no maximo 150 caracteres validos!');
      end;
    end;

    if (contato.telefone <> '') then
    begin
      if (Length(contato.telefone) < 8) then
      begin
        erros.Add('O telefone deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(contato.telefone) > 20) then
      begin
        erros.Add('O telefone deve conter no maximo 20 caracteres validos!');
      end;
    end;

    if (erros.Text = '') then
    begin
      contatoConsultado := contato.existeRegistro();

      if (Assigned(contatoConsultado)) then
      begin
        erros.Add('Já existe um contato [' + IntToStrSenaoZero(contatoConsultado.id) +
                  ' - ' + contatoConsultado.nome +
                  ' - ' + contatoConsultado.status + '] com esse mesmo nome e documento para esse cadastro!');
        contatoConsultado.Destroy;
      end
      else
      begin
        contatoConsultado := TContato.Create;
        contatoConsultado.tipoDocumento.Destroy;
        contatoConsultado.tipoDocumento := contato.tipoDocumento.consultarChave();

        if not (Assigned(contatoConsultado.tipoDocumento)) then
        begin
          erros.Add('Nenhum Tipo de Documento encontrado com o codigo [' + IntToStrSenaoZero(contato.tipoDocumento.id) + ']!');
        end
        else if (Length(Trim(soNumeros(contato.documento))) <> contatoConsultado.tipoDocumento.qtdeCaracteres) then
        begin
          erros.Add('O Numero do documento é invalido, deve conter ' + IntToStrSenaoZero(contatoConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
        end
        else
        begin
          contatoConsultado.pessoa.Destroy;
          contatoConsultado.pessoa := contato.pessoa.consultarChave();

          if not (Assigned(contatoConsultado.pessoa)) then
          begin
            erros.Add('Nenhum Pessoa encontrado com o codigo [' + IntToStrSenaoZero(contato.pessoa.id) + ']!');
          end;
        end;

        contatoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CONTATO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      contatoConsultado := contato.cadastrarContato();

      if Assigned(contatoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Contato');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(contato.registrosAfetados));
        montarContato(contatoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        contatoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Contato!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Contato!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  contato.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarContato(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  contatoConsultado: TContato;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'alterarContato', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    contato.pessoa.id := strToIntZero(Req.Params['pessoa']);
    contato.tipoDocumento.id := body.GetValue<Integer>('codigoTipoDocumento', 0);
    contato.documento := body.GetValue<string>('documento', '');
    contato.nome := body.GetValue<string>('nome', '');
    contato.dataNascimento := StrToDate(body.GetValue<string>('dataNascimento', ''));
    contato.funcao := body.GetValue<string>('funcao', '');
    contato.telefone := body.GetValue<string>('telefone', '');
    contato.email := body.GetValue<string>('email', '');
    contato.status := body.GetValue<string>('status', 'A');
    contato.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (contato.tipoDocumento.id > 0) then
    begin
      contato.tipoDocumento.id := contato.tipoDocumento.buscarRegistroCadastrar('NÃO INFORMADO', '', 0);
    end;

    if not (contato.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (contato.nome = '') then
    begin
      erros.Add('O nome do contato deve ser informado!');
    end
    else if (Length(contato.nome) <= 2) then
    begin
      erros.Add('O nome deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(contato.nome) > 150) then
    begin
      erros.Add('O nome deve conter no maximo 150 caracteres validos!');
    end;

    if (contato.email <> '') then
    begin
      if (Length(contato.email) < 8) then
      begin
        erros.Add('O email deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(contato.email) > 250) then
      begin
        erros.Add('O email deve conter no maximo 250 caracteres validos!');
      end;
    end;

    if (contato.funcao <> '') then
    begin
      if (Length(contato.funcao) < 3) then
      begin
        erros.Add('A função deve conter no minimo 3 caracteres validos!');
      end
      else if (Length(contato.funcao) > 150) then
      begin
        erros.Add('A função deve conter no maximo 150 caracteres validos!');
      end;
    end;

    if (contato.telefone <> '') then
    begin
      if (Length(contato.telefone) < 8) then
      begin
        erros.Add('O telefone deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(contato.telefone) > 20) then
      begin
        erros.Add('O telefone deve conter no maximo 20 caracteres validos!');
      end;
    end;

    if (contato.status <> 'A') and (contato.status <> 'I') then
    begin
      erros.Add('O Status da cidade informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      contatoConsultado := contato.consultarChave();

      if not (Assigned(contatoConsultado)) then
      begin
        erros.Add('Nenhum Contato encontrado com o codigo [' + IntToStrSenaoZero(contato.id) + '] para essa pessoa!');
      end
      else
      begin
        contatoConsultado.Destroy;
        contatoConsultado := contato.existeRegistro();

        if (Assigned(contatoConsultado)) then
        begin
          erros.Add('Já existe um contato [' + IntToStrSenaoZero(contatoConsultado.id) +
                  ' - ' + contatoConsultado.nome +
                  ' - ' + contatoConsultado.status + '] com esse mesmo nome e documento para esse cadastro!');
          contatoConsultado.Destroy;
        end;
      end;

      contatoConsultado := TContato.Create;
      contatoConsultado.tipoDocumento.Destroy;
      contatoConsultado.tipoDocumento := contato.tipoDocumento.consultarChave();

      if not (Assigned(contatoConsultado.tipoDocumento)) then
      begin
        erros.Add('Nenhum Tipo de documento encontrado com o codigo [' + IntToStrSenaoZero(contatoConsultado.tipoDocumento.id) + ']!');
      end
      else if (Length(Trim(soNumeros(contato.documento))) <> contatoConsultado.tipoDocumento.qtdeCaracteres) then
      begin
        erros.Add('O Numero do documento é invalido, deve conter ' + IntToStrSenaoZero(contatoConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
      end
      else
      begin
        contatoConsultado.pessoa.Destroy;
        contatoConsultado.pessoa := contato.pessoa.consultarChave();

        if not (Assigned(contatoConsultado.pessoa)) then
        begin
          erros.Add('Nenhum Pessoa encontrado com o codigo [' + IntToStrSenaoZero(contato.pessoa.id) + ']!');
        end;
      end;

      contatoConsultado.Destroy;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CONTATO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      contatoConsultado := contato.alterarContato();

      if Assigned(contatoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Contato');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(contato.registrosAfetados));
        montarContato(contatoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        contatoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Contato!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Contato!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  contato.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarContato(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  contatoConsultado: TContato;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogContato(Req, Res, 'inativarContato', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    contato.id := strToIntZero(Req.Params['id']);
    contato.pessoa.id := strToIntZero(Req.Params['pessoa']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (contato.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (contato.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      contatoConsultado := contato.consultarChave();

      if not (Assigned(contatoConsultado)) then
      begin
        erros.Add('Nenhum contato encontrado com o codigo [' + IntToStrSenaoZero(contato.id) + '] para essa pessoa!');
      end
      else
      begin
        contatoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('CONTATO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      contatoConsultado := contato.inativarContato();

      if Assigned(contatoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Contato');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(contato.registrosAfetados));
        montarContato(contatoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        contatoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Contato!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Contato!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('CONTATO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  contato.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/contato/:pessoa', buscarContatos);
  THorse.Post('/contato', cadastrarContato);
  THorse.Put('/contato/:pessoa/:id', alterarContato);
  THorse.Delete('/contato/:pessoa/:id', inativarContato);
end;

end.
