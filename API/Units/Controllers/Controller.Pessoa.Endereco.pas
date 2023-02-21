unit Controller.Pessoa.Endereco;

interface

uses Horse, System.SysUtils, Model.Pessoa.Endereco, System.JSON, System.Classes,
     Principal, UFuncao;

var
  endereco: TEndereco;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  endereco.limpar;
  token := '';
end;

procedure montarEndereco(enderecoItem: TEndereco; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(enderecoItem.id));
  resposta.AddPair('codigoPessoa',TJSONNumber.Create(enderecoItem.pessoa.id));
  resposta.AddPair('codigoTipoEndereco',TJSONNumber.Create(enderecoItem.tipoEndereco.id));
  resposta.AddPair('tipoEndereco',enderecoItem.tipoEndereco.descricao);
  resposta.AddPair('cep',enderecoItem.cep);
  resposta.AddPair('longradouro',enderecoItem.longradouro);
  resposta.AddPair('numero',enderecoItem.numero);
  resposta.AddPair('bairro',enderecoItem.bairro);
  resposta.AddPair('complemento',enderecoItem.complemento);
  resposta.AddPair('observacao',enderecoItem.observacao);
  resposta.AddPair('codigoCidade',TJSONNumber.Create(enderecoItem.cidade.id));
  resposta.AddPair('nomeCidade',enderecoItem.cidade.nome);
  resposta.AddPair('nomeEstado',enderecoItem.cidade.estado.nome);
  resposta.AddPair('nomePais',enderecoItem.cidade.estado.pais.nome);
  resposta.AddPair('prioridade',enderecoItem.prioridade);
  resposta.AddPair('cadastradoPor',enderecoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',enderecoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(enderecoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(enderecoItem.ultimaAlteracao));
  resposta.AddPair('status',enderecoItem.status);
end;

function gerarLogEndereco(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := endereco.GerarLog('Endereco',
                                procedimento,
                                imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    endereco := TEndereco.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Endereço');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    endereco.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Endereço');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (endereco.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarEnderecos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  enderecos: TArray<TEndereco>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEndereco(Req, Res, 'buscarEnderecos', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    endereco.id := strToIntZero(Req.Query['codigo']);
    endereco.status := Req.Query['status'];
    endereco.limite := strToIntZero(Req.Query['limite']);
    endereco.offset := strToIntZero(Req.Query['offset']);
    endereco.pessoa.id := strToIntZero(Req.Params['pessoa']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (endereco.pessoa.id > 0) then
  begin
    mensagem := 'O codigo da pessoa deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (endereco.status = '') then
  begin
    endereco.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (endereco.pessoa.id > 0) or
       (endereco.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    enderecos := endereco.consultar();
    quantidade := Length(enderecos);

    resposta.AddPair('tipo', 'consulta Endereços');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(endereco.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(endereco.limite));
    resposta.AddPair('offset', TJSONNumber.Create(endereco.offset));

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
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarEndereco(enderecos[i], temporario);
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

      arrayResposta.Add(UFuncao.JsonErro('ENDERECO003', 'Erro não tratado ao listar todos os Endereços!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  endereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  enderecoConsultado: TEndereco;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEndereco(Req, Res, 'cadastrarEndereco', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    endereco.pessoa.id := body.GetValue<Integer>('codigoPessoa', 0);
    endereco.tipoEndereco.id := body.GetValue<Integer>('codigoTipoEndereco', 0);
    endereco.cep := body.GetValue<string>('cep', '');
    endereco.longradouro := body.GetValue<string>('longradouro', '');
    endereco.numero := body.GetValue<string>('numero', '');
    endereco.bairro := body.GetValue<string>('bairro', '');
    endereco.complemento := body.GetValue<string>('complemento', '');
    endereco.observacao := body.GetValue<string>('observacao', '');
    endereco.cidade.id := body.GetValue<Integer>('codigoCidade', 0);
    endereco.prioridade := body.GetValue<string>('prioridade', '');
    endereco.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (endereco.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (endereco.tipoEndereco.id > 0) then
    begin
      erros.Add('O Codigo do tipo de endereço deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (endereco.cep = '') then
    begin
      erros.Add('O CEP deve ser informado!');
    end
    else if (Length(soNumeros(Trim(endereco.cep))) <> 8) then
    begin
      erros.Add('O CEP deve conter 8 caracteres numericos valido!');
    end;

    if (endereco.longradouro = '') then
    begin
      erros.Add('O longradouro deve ser informado!');
    end
    else if (Length(endereco.longradouro) <= 2) then
    begin
      erros.Add('O longradouro deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(endereco.longradouro) > 150) then
    begin
      erros.Add('O longradouro deve conter no maximo 150 caracteres validos!');
    end;

    if (endereco.complemento <> '') then
    begin
      if (Length(endereco.complemento) <= 2) then
      begin
        erros.Add('O complemento deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(endereco.complemento) > 150) then
      begin
        erros.Add('O complemento deve conter no maximo 150 caracteres validos!');
      end;
    end;

    if (endereco.numero = '') then
    begin
      erros.Add('O numero deve ser informado!');
    end
    else if (Length(Trim(endereco.longradouro)) > 10) then
    begin
      erros.Add('O numero deve conter no maximo 10 caracteres validos!');
    end;

    if (endereco.bairro = '') then
    begin
      erros.Add('O bairro deve ser informado!');
    end
    else if (Length(Trim(endereco.bairro)) <= 2) then
    begin
      erros.Add('O bairro deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(endereco.bairro)) > 150) then
    begin
      erros.Add('O bairro deve conter no maximo 150 caracteres validos!');
    end;

    if (endereco.prioridade = '') then
    begin
      erros.Add('Se o endereço é principal ou secundario deve ser informado!');
    end
    else if (endereco.prioridade <> 'P') and (endereco.prioridade <> 'S') then
    begin
      erros.Add('Se o endereço é principal ou secundario foi informado incorretamente!');
    end;

    if (erros.Text = '') then
    begin
      enderecoConsultado := endereco.existeRegistro();

      if (Assigned(enderecoConsultado)) then
      begin
        erros.Add('Já existe um endereço [' + IntToStrSenaoZero(enderecoConsultado.id) +
                  ' - ' + enderecoConsultado.cep +
                  ' - ' + enderecoConsultado.status + '] com esse mesmo CEP para esse cadastro!');
        enderecoConsultado.Destroy;
      end
      else
      begin
        enderecoConsultado := TEndereco.Create;
        enderecoConsultado.tipoEndereco.Destroy;
        enderecoConsultado.tipoEndereco := endereco.tipoEndereco.consultarChave();

        if not (Assigned(enderecoConsultado.tipoEndereco)) then
        begin
          erros.Add('Nenhum Tipo de Endereço encontrado com o codigo [' + IntToStrSenaoZero(endereco.tipoEndereco.id) + ']!');
        end
        else
        begin
          enderecoConsultado.pessoa.Destroy;
          enderecoConsultado.pessoa := endereco.pessoa.consultarChave();

          if not (Assigned(enderecoConsultado.pessoa)) then
          begin
            erros.Add('Nenhum Pessoa encontrado com o codigo [' + IntToStrSenaoZero(endereco.pessoa.id) + ']!');
          end
          else
          begin
            enderecoConsultado.cidade.Destroy;
            enderecoConsultado.cidade := endereco.cidade.consultarChave();

            if not (Assigned(enderecoConsultado.cidade)) then
            begin
              erros.Add('Nenhuma Cidade encontrada com o codigo [' + IntToStrSenaoZero(endereco.cidade.id) + ']!');
            end;
          end;
        end;

        enderecoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ENDERECO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      enderecoConsultado := endereco.cadastrarEndereco();

      if Assigned(enderecoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Endereço');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(endereco.registrosAfetados));
        montarEndereco(enderecoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        enderecoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Endereço!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  endereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  enderecoConsultado: TEndereco;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEndereco(Req, Res, 'alterarEndereco', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    endereco.pessoa.id := strToIntZero(Req.Params['pessoa']);
    endereco.tipoEndereco.id := body.GetValue<Integer>('codigoTipoEndereco', 0);
    endereco.cep := body.GetValue<string>('cep', '');
    endereco.longradouro := body.GetValue<string>('longradouro', '');
    endereco.numero := body.GetValue<string>('numero', '');
    endereco.bairro := body.GetValue<string>('bairro', '');
    endereco.complemento := body.GetValue<string>('complemento', '');
    endereco.observacao := body.GetValue<string>('observacao', '');
    endereco.cidade.id := body.GetValue<Integer>('codigoCidade', 0);
    endereco.prioridade := body.GetValue<string>('prioridade', '');
    endereco.status := body.GetValue<string>('status', 'A');
    endereco.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (endereco.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (endereco.tipoEndereco.id > 0) then
    begin
      erros.Add('O Codigo do tipo de endereço deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (endereco.cep = '') then
    begin
      erros.Add('O CEP deve ser informado!');
    end
    else if (Length(soNumeros(Trim(endereco.cep))) <> 8) then
    begin
      erros.Add('O CEP deve conter 8 caracteres numericos valido!');
    end;

    if (endereco.complemento <> '') then
    begin
      if (Length(endereco.complemento) <= 2) then
      begin
        erros.Add('O complemento deve conter no minimo 2 caracteres validos!');
      end
      else if (Length(endereco.complemento) > 150) then
      begin
        erros.Add('O complemento deve conter no maximo 150 caracteres validos!');
      end;
    end;

    if (endereco.longradouro = '') then
    begin
      erros.Add('O longradouro deve ser informado!');
    end
    else if (Length(Trim(endereco.longradouro)) <= 2) then
    begin
      erros.Add('O longradouro deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(endereco.longradouro)) > 150) then
    begin
      erros.Add('O longradouro deve conter no maximo 150 caracteres validos!');
    end;

    if (endereco.numero = '') then
    begin
      erros.Add('O numero deve ser informado!');
    end
    else if (Length(Trim(endereco.longradouro)) > 10) then
    begin
      erros.Add('O numero deve conter no maximo 10 caracteres validos!');
    end;

    if (endereco.bairro = '') then
    begin
      erros.Add('O bairro deve ser informado!');
    end
    else if (Length(Trim(endereco.bairro)) <= 2) then
    begin
      erros.Add('O bairro deve conter no minimo 2 caracteres validos!');
    end
    else if (Length(Trim(endereco.bairro)) > 150) then
    begin
      erros.Add('O bairro deve conter no maximo 150 caracteres validos!');
    end;

    if (endereco.prioridade = '') then
    begin
      erros.Add('Se o endereço é principal ou secundario deve ser informado!');
    end
    else if (endereco.prioridade <> 'P') and (endereco.prioridade <> 'S') then
    begin
      erros.Add('Se o endereço é principal ou secundario foi informado incorretamente!');
    end;

    if (endereco.status <> 'A') and (endereco.status <> 'I') then
    begin
      erros.Add('O Status da cidade informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      enderecoConsultado := endereco.consultarChave();

      if not (Assigned(enderecoConsultado)) then
      begin
        erros.Add('Nenhum Endereço encontrado com o codigo [' + IntToStrSenaoZero(endereco.id) + '] para essa pessoa!');
      end
      else
      begin
        enderecoConsultado.Destroy;
        enderecoConsultado := endereco.existeRegistro();

        if (Assigned(enderecoConsultado)) then
        begin
          erros.Add('Já existe um Endereço [' + IntToStrSenaoZero(enderecoConsultado.id) +
                  ' - ' + enderecoConsultado.cep +
                  ' - ' + enderecoConsultado.status + '] com esse mesmo CEP para esse cadastro!');
          enderecoConsultado.Destroy;
        end;
      end;

      enderecoConsultado := TEndereco.Create;
      enderecoConsultado.tipoEndereco.Destroy;
      enderecoConsultado.tipoEndereco := endereco.tipoEndereco.consultarChave();

      if not (Assigned(enderecoConsultado.tipoEndereco)) then
      begin
        erros.Add('Nenhum Tipo de Endereço encontrado com o codigo [' + IntToStrSenaoZero(enderecoConsultado.tipoEndereco.id) + ']!');
      end
      else
      begin
        enderecoConsultado.pessoa.Destroy;
        enderecoConsultado.pessoa := endereco.pessoa.consultarChave();

        if not (Assigned(enderecoConsultado.pessoa)) then
        begin
          erros.Add('Nenhum Pessoa encontrado com o codigo [' + IntToStrSenaoZero(endereco.pessoa.id) + ']!');
        end
        else
        begin
          enderecoConsultado.cidade.Destroy;
          enderecoConsultado.cidade := endereco.cidade.consultarChave();

          if not (Assigned(enderecoConsultado.cidade)) then
          begin
            erros.Add('Nenhuma Cidade encontrada com o codigo [' + IntToStrSenaoZero(endereco.cidade.id) + ']!');
          end;
        end;
      end;

      enderecoConsultado.Destroy;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ENDERECO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      enderecoConsultado := endereco.alterarEndereco();

      if Assigned(enderecoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Endereço');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(endereco.registrosAfetados));
        montarEndereco(enderecoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        enderecoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Endereço!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  endereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarEndereco(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  enderecoConsultado: TEndereco;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogEndereco(Req, Res, 'inativarEndereco', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    endereco.id := strToIntZero(Req.Params['id']);
    endereco.pessoa.id := strToIntZero(Req.Params['pessoa']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (endereco.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (endereco.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      enderecoConsultado := endereco.consultarChave();

      if not (Assigned(enderecoConsultado)) then
      begin
        erros.Add('Nenhum Endereço encontrado com o codigo [' + IntToStrSenaoZero(endereco.id) + '] para essa pessoa!');
      end
      else
      begin
        enderecoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('ENDERECO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      enderecoConsultado := endereco.inativarEndereco();

      if Assigned(enderecoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Endereço');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(endereco.registrosAfetados));
        montarEndereco(enderecoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        enderecoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Endereço!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Endereço!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('ENDERECO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  endereco.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/endereco/:pessoa', buscarEnderecos);
  THorse.Post('/endereco', cadastrarEndereco);
  THorse.Put('/endereco/:pessoa/:id', alterarEndereco);
  THorse.Delete('/endereco/:pessoa/:id', inativarEndereco);
end;

end.
