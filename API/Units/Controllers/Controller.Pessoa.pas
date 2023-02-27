unit Controller.Pessoa;

interface

uses Horse, System.SysUtils, Model.Pessoa, System.JSON, System.Classes,
     Principal, UFuncao;

var
  pessoa: TPessoa;
  token: string;
  continuar: Boolean;
  const tpCliente = 1;
  const tpFornecedor = 2;
  const tpFuncionario = 3;
  const tpUsuario = 4;

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

  if pessoaItem.tipoPessoa.id in [tpCliente, tpFornecedor] then
  begin
    resposta.AddPair('razaoSocial', pessoaItem.razaoSocial);
    resposta.AddPair('nomeFantasia', pessoaItem.nomeFantasia);
  end
  else
  begin
    resposta.AddPair('nome', pessoaItem.razaoSocial);
  end;

  resposta.AddPair('telefone', pessoaItem.telefone);
  resposta.AddPair('email', pessoaItem.email);

  if pessoaItem.tipoPessoa.id = tpUsuario then
  begin
    resposta.AddPair('senha', pessoaItem.senha);
  end;

  resposta.AddPair('observacao', pessoaItem.observacao);
  resposta.AddPair('cadastradoPor', pessoaItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor', pessoaItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro', DateTimeToStr(pessoaItem.dataCadastro));
  resposta.AddPair('dataAlteracao', DateTimeToStr(pessoaItem.ultimaAlteracao));
  resposta.AddPair('status', pessoaItem.status);
end;

function gerarLogPessoa(Req: THorseRequest; Res: THorseResponse; procedimento, classe: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := pessoa.GerarLog(classe,
                              procedimento,
                              imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
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

function verificarToken(Res: THorseResponse; classe: string; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (pessoa.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc; procedimento, classe: string; tipoPessoa: integer);
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
  codigoLog := gerarLogPessoa(Req, Res, procedimento, classe, resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    pessoa.id := strToIntZero(Req.Query['codigo']);
    pessoa.tipoPessoa.id := tipoPessoa;
    pessoa.documento := Req.Query['documento'];

    if verificarToken(res, classe, resposta) then
    begin
      if (tipoPessoa in[tpFuncionario, tpUsuario]) then
      begin
        pessoa.tipoDocumento.id := pessoa.tipoDocumento.buscarRegistroCadastrar('CPF', '999.999.999-99', 11);
        pessoa.tipoDocumento.descricao := 'CPF';
        pessoa.razaoSocial := Req.Query['nome'];
        pessoa.nomeFantasia := Req.Query['nome'];
      end
      else
      begin
        pessoa.tipoDocumento.id := strToIntZero(Req.Query['codigoTipoDocumento']);
        pessoa.tipoDocumento.descricao := Req.Query['tipoDocumento'];
        pessoa.razaoSocial := Req.Query['razaoSocial'];
        pessoa.nomeFantasia := Req.Query['nomeFantasia'];
      end;

      pessoa.telefone := Req.Query['telefone'];
      pessoa.email := Req.Query['email'];
      pessoa.observacao := Req.Query['observacao'];
      pessoa.status := Req.Query['status'];
      pessoa.limite := strToIntZero(Req.Query['limite']);
      pessoa.offset := strToIntZero(Req.Query['offset']);
    end
    else
    begin
      continuar := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (pessoa.status = '') then
  begin
    pessoa.status := 'A';
  end;

  if (continuar) then
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

    resposta.AddPair('tipo', 'consulta ' + classe);
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
        mensagem := 'Erro ao consultar ' + classe + '!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '002', mensagem))));
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

      arrayResposta.Add(UFuncao.JsonErro(UpperCase(classe) + '003', 'Erro não tratado ao listar ' + classe + '!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc; procedimento, classe: string; tipoPessoa: integer);
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
  codigoLog := gerarLogPessoa(Req, Res, procedimento, classe, resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    pessoa.tipoPessoa.id := tipoPessoa;

    if verificarToken(res, classe, resposta) then
    begin
      if (tipoPessoa in[tpFuncionario, tpUsuario]) then
      begin
        pessoa.tipoDocumento.id := pessoa.tipoDocumento.buscarRegistroCadastrar('CPF', '999.999.999-99', 11);
        pessoa.documento := body.GetValue<string>('documento', '');
        pessoa.razaoSocial := body.GetValue<string>('nome');
        pessoa.nomeFantasia := body.GetValue<string>('nome');

        if (tipoPessoa = tpUsuario) then
        begin
          pessoa.senha := body.GetValue<string>('senha', '');
        end
        else
        begin
          pessoa.senha := '';
        end;
      end
      else
      begin
        pessoa.tipoDocumento.id := body.GetValue<integer>('codigoTipoDocumento', 0);
        pessoa.documento := body.GetValue<string>('documento', '');
        pessoa.razaoSocial := body.GetValue<string>('razaoSocial', '');
        pessoa.nomeFantasia := body.GetValue<string>('nomeFantasia', '');
      end;

      pessoa.telefone := body.GetValue<string>('telefone', '');
      pessoa.email := body.GetValue<string>('email', '');
      pessoa.observacao := body.GetValue<string>('observacao', '');
      pessoa.id := 0;
    end
    else
    begin
      continuar := False;
    end;

    pessoa.documento := trim(soNumeros(pessoa.documento));
    pessoa.telefone := trim(soNumeros(pessoa.telefone));
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if (tipoPessoa in[tpCliente, tpFornecedor]) then
    begin
      if (pessoa.razaoSocial = '') then
      begin
        erros.Add('A Razão Social deve ser informada!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) <= 2) then
      begin
        erros.Add('A Razão Social deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) > 150) then
      begin
        erros.Add('A Razão Social deve conter no maximo 150 caracteres validos!');
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
    end
    else
    begin
      if (pessoa.razaoSocial = '') then
      begin
        erros.Add('O nome deve ser informado!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) <= 2) then
      begin
        erros.Add('O nome deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) > 150) then
      begin
        erros.Add('O nome deve conter no maximo 150 caracteres validos!');
      end;

      if (tipoPessoa = tpUsuario) then
      begin
        if (pessoa.senha = '') then
        begin
          erros.Add('A senha deve ser informada!');
        end
        else if (Length(pessoa.senha) < 6) then
        begin
          erros.Add('A senha deve conter no minimo 6 caracteres validos!');
        end
        else if (Length(pessoa.senha) > 250) then
        begin
          erros.Add('A senha deve conter no maximo 250 caracteres validos!');
        end;
      end;
    end;

    if (pessoa.telefone <> '') then
    begin
      if (Length(pessoa.telefone) < 8) then
      begin
        erros.Add('O telefone deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(pessoa.telefone) > 20) then
      begin
        erros.Add('O telefone deve conter no maximo 20 caracteres validos!');
      end;
    end;

    if (pessoa.email <> '') then
    begin
      if (Length(pessoa.email) < 8) then
      begin
        erros.Add('O email deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(pessoa.email) > 250) then
      begin
        erros.Add('O email deve conter no maximo 250 caracteres validos!');
      end;
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.existeRegistro();

      if (Assigned(pessoaConsultado)) then
      begin
        erros.Add('Já existe um ' + classe + ' [' + IntToStrSenaoZero(pessoaConsultado.id) +
                  ' - ' + pessoaConsultado.nomeFantasia +
                  ' - ' + pessoaConsultado.status + '], cadastrado com esse documento!');

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
          erros.Add('O Numero do documento é invalido, deve conter ' + IntToStrSenaoZero(pessoaConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
        end;

        pessoaConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro(UpperCase(classe) + '006',  erros[i]));
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
        resposta.AddPair('tipo', 'Cadastro de ' + classe);
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        montarPessoa(pessoaConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        pessoaConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um ' + classe + '!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um ' + classe + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc; procedimento, classe: string; tipoPessoa: integer);
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
  codigoLog := gerarLogPessoa(Req, Res, procedimento, classe, resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    pessoa.tipoPessoa.id := tipoPessoa;

    if verificarToken(res, classe, resposta) then
    begin
      if (tipoPessoa in[tpFuncionario, tpUsuario]) then
      begin
        pessoa.tipoDocumento.id := pessoa.tipoDocumento.buscarRegistroCadastrar('CPF', '999.999.999-99', 11);
        pessoa.documento := body.GetValue<string>('documento', '');
        pessoa.razaoSocial := body.GetValue<string>('nome', '');
        pessoa.nomeFantasia := body.GetValue<string>('nome', '');

        if (tipoPessoa = tpUsuario) then
        begin
          pessoa.senha := body.GetValue<string>('senha', '');
        end
        else
        begin
          pessoa.senha := '';
        end;
      end
      else
      begin
        pessoa.tipoDocumento.id := body.GetValue<integer>('codigoTipoDocumento', 0);
        pessoa.documento := body.GetValue<string>('documento', '');
        pessoa.razaoSocial := body.GetValue<string>('razaoSocial', '');
        pessoa.nomeFantasia := body.GetValue<string>('nomeFantasia', '');
      end;

      pessoa.telefone := body.GetValue<string>('telefone', '');
      pessoa.email := body.GetValue<string>('email', '');
      pessoa.observacao := body.GetValue<string>('observacao', '');
      pessoa.id := strToIntZero(Req.Params['id']);
      pessoa.status := body.GetValue<string>('status', '');
    end
    else
    begin
      continuar := False;
    end;

    pessoa.documento := trim(soNumeros(pessoa.documento));
    pessoa.telefone := trim(soNumeros(pessoa.telefone));
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pessoa.id > 0) then
    begin
      erros.Add('O Codigo do ' + classe  + ' deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (tipoPessoa in[tpCliente, tpFornecedor]) then
    begin
      if (pessoa.razaoSocial = '') then
      begin
        erros.Add('A Razão Social deve ser informada!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) <= 2) then
      begin
        erros.Add('A Razão Social deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) > 150) then
      begin
        erros.Add('A Razão Social deve conter no maximo 150 caracteres validos!');
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
    end
    else
    begin
      if (pessoa.razaoSocial = '') then
      begin
        erros.Add('O nome deve ser informado!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) <= 2) then
      begin
        erros.Add('O nome deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(Trim(pessoa.razaoSocial)) > 150) then
      begin
        erros.Add('O nome deve conter no maximo 150 caracteres validos!');
      end;

      if (tipoPessoa = tpUsuario) then
      begin
        if (pessoa.senha = '') then
        begin
          erros.Add('A senha deve ser informada!');
        end
        else if (Length(pessoa.senha) < 6) then
        begin
          erros.Add('A senha deve conter no minimo 6 caracteres validos!');
        end
        else if (Length(pessoa.senha) > 250) then
        begin
          erros.Add('A senha deve conter no maximo 250 caracteres validos!');
        end;
      end;
    end;

    if (pessoa.telefone = '') then
    begin
      if (Length(pessoa.telefone) < 8) then
      begin
        erros.Add('O telefone deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(pessoa.telefone) > 20) then
      begin
        erros.Add('O telefone deve conter no maximo 20 caracteres validos!');
      end;
    end;

    if (pessoa.email = '') then
    begin
      if (Length(pessoa.email) < 8) then
      begin
        erros.Add('O email deve conter no minimo 8 caracteres validos!');
      end
      else if (Length(pessoa.email) > 250) then
      begin
        erros.Add('O email deve conter no maximo 250 caracteres validos!');
      end;
    end;

    if (pessoa.status <> 'A') and (pessoa.status <> 'I') then
    begin
      erros.Add('O Status do ' + classe + ' informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.consultarChave();

      if not (Assigned(pessoaConsultado)) then
      begin
        erros.Add('Nenhuma ' + classe + ' encontrado com o codigo [' + IntToStrSenaoZero(pessoa.id) + ']!');
      end
      else
      begin
        pessoaConsultado.Destroy;
        pessoaConsultado := pessoa.existeRegistro();

        if (Assigned(pessoaConsultado)) then
        begin
          erros.Add('Já existe um ' + classe + ' [' + IntToStrSenaoZero(pessoaConsultado.id) +
                    ' - ' + pessoaConsultado.nomeFantasia +
                  ' - ' + pessoaConsultado.status + '], cadastrado com esse documento!');
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
            erros.Add('O Numero do documento é invalido, deve conter ' + IntToStrSenaoZero(pessoaConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
          end;

          pessoaConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro(UpperCase(classe) + '013',  erros[i]));
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
        resposta.AddPair('tipo', 'Alteração de ' + classe);
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        montarPessoa(pessoaConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        pessoaConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um ' + classe + '!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um ' + classe + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc; procedimento, classe: string; tipoPessoa: integer);
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
  codigoLog := gerarLogPessoa(Req, Res, procedimento, classe, resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    pessoa.id := strToIntZero(Req.Params['id']);
    pessoa.tipoPessoa.id := tipoPessoa;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(JsonErro(UpperCase(classe) + '015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, classe, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pessoa.id > 0) then
    begin
      erros.Add('O Codigo do ' + classe + ' deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.consultarChave();

      if not (Assigned(pessoaConsultado)) then
      begin
        erros.Add('Nenhum ' + classe + ' encontrado com o codigo [' + IntToStrSenaoZero(pessoa.id) + ']!');
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
        arrayResposta.Add(UFuncao.JsonErro(UpperCase(classe) + '016',  erros[i]));
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
        resposta.AddPair('tipo', 'Inativação de ' + classe);
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        montarPessoa(pessoaConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        pessoaConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um' + classe + '!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um' + classe + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure excluirPessoa(Req: THorseRequest; Res: THorseResponse; Next: TProc; procedimento, classe: string; tipoPessoa: integer);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  pessoaConsultado: TPessoa;
  i: integer;
  resultado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogPessoa(Req, Res, procedimento, classe, resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    pessoa.id := strToIntZero(Req.Params['id']);
    pessoa.tipoPessoa.id := tipoPessoa;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(JsonErro(UpperCase(classe) + '015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, classe, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (pessoa.id > 0) then
    begin
      erros.Add('O Codigo do ' + classe + ' deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      pessoaConsultado := pessoa.consultarChave();

      if not (Assigned(pessoaConsultado)) then
      begin
        erros.Add('Nenhum ' + classe + ' encontrado com o codigo [' + IntToStrSenaoZero(pessoa.id) + ']!');
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
        arrayResposta.Add(UFuncao.JsonErro(UpperCase(classe) + '016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      resultado := pessoa.excluirCadastro;

      if (resultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de ' + classe);
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(pessoa.registrosAfetados));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Não foi possivel excluir esse ' + classe + ', pois o mesmo está sendo usado em outro registro!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao excluir um ' + classe + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro(UpperCase(classe) + '017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  pessoa.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure buscarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  buscarPessoa(Req, Res, Next, 'buscarCliente', 'Cliente', tpCliente);
end;

procedure cadastrarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  cadastrarPessoa(Req, Res, Next, 'cadastrarCliente', 'Cliente', tpCliente);
end;

procedure alterarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  alterarPessoa(Req, Res, Next, 'alterarCliente', 'Cliente', tpCliente);
end;

procedure inativarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  inativarPessoa(Req, Res, Next, 'inativarCliente', 'Cliente', tpCliente);
end;

procedure excluirCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  excluirPessoa(Req, Res, Next, 'excluirCliente', 'Cliente', tpCliente);
end;

procedure buscarFornecedor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  buscarPessoa(Req, Res, Next, 'buscarFornecedor', 'Fornecedor', tpFornecedor);
end;

procedure cadastrarFornecedor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  cadastrarPessoa(Req, Res, Next, 'cadastrarFornecedor', 'Fornecedor', tpFornecedor);
end;

procedure alterarFornecedor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  alterarPessoa(Req, Res, Next, 'alterarFornecedor', 'Fornecedor', tpFornecedor);
end;

procedure inativarFornecedor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  inativarPessoa(Req, Res, Next, 'inativarFornecedor', 'Fornecedor', tpFornecedor);
end;

procedure excluirFornecedor(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  excluirPessoa(Req, Res, Next, 'excluirFornecedor', 'Fornecedor', tpFornecedor);
end;

procedure buscarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  buscarPessoa(Req, Res, Next, 'buscarUsuario', 'Usuario', tpUsuario);
end;

procedure cadastrarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  cadastrarPessoa(Req, Res, Next, 'cadastrarUsuario', 'Usuario', tpUsuario);
end;

procedure alterarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  alterarPessoa(Req, Res, Next, 'alterarUsuario', 'Usuario', tpUsuario);
end;

procedure inativarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  inativarPessoa(Req, Res, Next, 'inativarUsuario', 'Usuario', tpUsuario);
end;

procedure excluirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  excluirPessoa(Req, Res, Next, 'excluirUsuario', 'Usuario', tpUsuario);
end;

procedure buscarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  buscarPessoa(Req, Res, Next, 'buscarFuncionario', 'Funcionario', tpFuncionario);
end;

procedure cadastrarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  cadastrarPessoa(Req, Res, Next, 'cadastrarFuncionario', 'Funcionario', tpFuncionario);
end;

procedure alterarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  alterarPessoa(Req, Res, Next, 'alterarFuncionario', 'Funcionario', tpFuncionario);
end;

procedure inativarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  inativarPessoa(Req, Res, Next, 'inativarFuncionario', 'Funcionario', tpFuncionario);
end;

procedure excluirFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  excluirPessoa(Req, Res, Next, 'excluirFuncionario', 'Funcionario', tpFuncionario);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/cliente', buscarCliente);
  THorse.Post('/cliente', cadastrarCliente);
  THorse.Put('/cliente/:id', alterarCliente);
  THorse.Delete('/cliente/:id', inativarCliente);
  THorse.Delete('/clienteExcluir/:id', excluirCliente);

  THorse.Get('/fornecedor', buscarFornecedor);
  THorse.Post('/fornecedor', cadastrarFornecedor);
  THorse.Put('/fornecedor/:id', alterarFornecedor);
  THorse.Delete('/fornecedor/:id', inativarFornecedor);
  THorse.Delete('/fornecedorExcluir/:id', excluirFornecedor);

  THorse.Get('/usuario', buscarUsuario);
  THorse.Post('/usuario', cadastrarUsuario);
  THorse.Put('/usuario/:id', alterarUsuario);
  THorse.Delete('/usuario/:id', inativarUsuario);
  THorse.Delete('/usuarioExcluir/:id', excluirUsuario);

  THorse.Get('/funcionario', buscarFuncionario);
  THorse.Post('/funcionario', cadastrarFuncionario);
  THorse.Put('/funcionario/:id', alterarFuncionario);
  THorse.Delete('/funcionario/:id', inativarFuncionario);
  THorse.Delete('/funcionarioExcluir/:id', excluirFuncionario);
end;

end.
