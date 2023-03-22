unit Controller.Pessoa.OutroDocumento;

interface

uses Horse, System.SysUtils, Model.Pessoa.OutroDocumento, System.JSON, System.Classes,
     Principal, UFuncao;

var
  outroDocumento: TOutroDocumento;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  outroDocumento.limpar;
  token := '';
end;

procedure montarOutroDocumento(outroDocumentoItem: TOutroDocumento; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(outroDocumentoItem.id));
  resposta.AddPair('codigoPessoa',TJSONNumber.Create(outroDocumentoItem.pessoa.id));
  resposta.AddPair('codigoTipoDocumento',TJSONNumber.Create(outroDocumentoItem.tipoDocumento.id));
  resposta.AddPair('TipoDocumento',outroDocumentoItem.tipoDocumento.descricao);
  resposta.AddPair('mascaraCaracteres',outroDocumentoItem.tipoDocumento.mascara);
  resposta.AddPair('documento',outroDocumentoItem.documento);
  resposta.AddPair('dataEmissao',DateToStr(outroDocumentoItem.dataEmissao));
  resposta.AddPair('dataVencimento',DateToStr(outroDocumentoItem.dataVencimento));
  resposta.AddPair('observacao',outroDocumentoItem.observacao);
  resposta.AddPair('cadastradoPor',outroDocumentoItem.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',outroDocumentoItem.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(outroDocumentoItem.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(outroDocumentoItem.ultimaAlteracao));
  resposta.AddPair('status',outroDocumentoItem.status);
end;

function gerarLogOutroDocumento(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := outroDocumento.GerarLog('OutroDocumento',
                                      procedimento,
                                      imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    outroDocumento := TOutroDocumento.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Outro Documento');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    outroDocumento.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Outro Documento');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (outroDocumento.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarOutrosDocumentos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  outrosDocumentos: TArray<TOutroDocumento>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOutroDocumento(Req, Res, 'buscarOutrosDocumentos', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    outroDocumento.id := strToIntZero(Req.Query['codigo']);
    outroDocumento.status := Req.Query['status'];
    outroDocumento.limite := strToIntZero(Req.Query['limite']);
    outroDocumento.offset := strToIntZero(Req.Query['offset']);
    outroDocumento.pessoa.id := strToIntZero(Req.Params['pessoa']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (outroDocumento.pessoa.id > 0) then
  begin
    mensagem := 'O codigo da pessoa deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (outroDocumento.status = '') then
  begin
    outroDocumento.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (outroDocumento.pessoa.id > 0) or
       (outroDocumento.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    outrosDocumentos := outroDocumento.consultar();
    quantidade := Length(outrosDocumentos);

    resposta.AddPair('tipo', 'consulta Outros Documentos');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(outroDocumento.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(outroDocumento.limite));
    resposta.AddPair('offset', TJSONNumber.Create(outroDocumento.offset));

    if not Assigned(outrosDocumentos) then
    begin
      if (Length(outrosDocumentos) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Outros documentos!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarOutroDocumento(outrosDocumentos[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      outrosDocumentos[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('OUTRODOCUMENTO003', 'Erro não tratado ao listar todos os Outros documentos!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  outroDocumento.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarOutroDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  outroDocumentoConsultado: TOutroDocumento;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOutroDocumento(Req, Res, 'cadastrarOutroDocumento', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    outroDocumento.pessoa.id := body.GetValue<Integer>('codigoPessoa', 0);
    outroDocumento.tipoDocumento.id := body.GetValue<Integer>('codigoTipoDocumento', 0);
    outroDocumento.documento := body.GetValue<string>('documento', '');
    outroDocumento.dataEmissao := StrToDate(body.GetValue<string>('dataEmissao', ''));
    outroDocumento.dataVencimento := StrToDate(body.GetValue<string>('dataVencimento', ''));
    outroDocumento.observacao := body.GetValue<string>('observacao', '');
    outroDocumento.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (outroDocumento.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (outroDocumento.tipoDocumento.id > 0) then
    begin
      erros.Add('O Codigo do tipo de documento deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      outroDocumentoConsultado := outroDocumento.existeRegistro();

      if (Assigned(outroDocumentoConsultado)) then
      begin
        erros.Add('Já existe um outro documento [' + IntToStrSenaoZero(outroDocumentoConsultado.id) +
                  ' - ' + outroDocumentoConsultado.documento +
                  ' - ' + outroDocumentoConsultado.status + '] com esse mesmo numero para esse cadastro!');
        outroDocumentoConsultado.Destroy;
      end
      else
      begin
        outroDocumentoConsultado := TOutroDocumento.Create;
        outroDocumentoConsultado.tipoDocumento.Destroy;
        outroDocumentoConsultado.tipoDocumento := outroDocumento.tipoDocumento.consultarChave();

        if not (Assigned(outroDocumentoConsultado.tipoDocumento)) then
        begin
          erros.Add('Nenhum Tipo de Documento encontrado com o codigo [' + IntToStrSenaoZero(outroDocumento.tipoDocumento.id) + ']!');
        end
        else if (Length(Trim(soNumeros(outroDocumento.documento))) <> outroDocumentoConsultado.tipoDocumento.qtdeCaracteres) then
        begin
          erros.Add('O Numero do documento é invalido, deve conter ' + IntToStrSenaoZero(outroDocumentoConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
          outroDocumentoConsultado.Destroy;
        end
        else
        begin
          outroDocumentoConsultado.pessoa.Destroy;
          outroDocumentoConsultado.pessoa := outroDocumento.pessoa.consultarChaveSemTipo();

          if not (Assigned(outroDocumentoConsultado.pessoa)) then
          begin
            erros.Add('Nenhum Pessoa encontrado com o codigo [' + IntToStrSenaoZero(outroDocumento.pessoa.id) + ']!');
          end;
        end;

        outroDocumentoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('OUTRODOCUMENTO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      outroDocumentoConsultado := outroDocumento.cadastrarOutroDocumento();

      if Assigned(outroDocumentoConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Outros Documentos');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(outroDocumento.registrosAfetados));
        montarOutroDocumento(outroDocumentoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        outroDocumentoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Outro Documento!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Outro Documento!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  outroDocumento.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarOutroDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  outroDocumentoConsultado: TOutroDocumento;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOutroDocumento(Req, Res, 'alterarOutroDocumento', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    outroDocumento.pessoa.id := strToIntZero(Req.Params['pessoa']);
    outroDocumento.tipoDocumento.id := body.GetValue<Integer>('codigoTipoDocumento', 0);
    outroDocumento.documento := body.GetValue<string>('documento', '');
    outroDocumento.dataEmissao := StrToDate(body.GetValue<string>('dataEmissao', ''));
    outroDocumento.dataVencimento := StrToDate(body.GetValue<string>('dataVencimento', ''));
    outroDocumento.observacao := body.GetValue<string>('observacao', '');
    outroDocumento.status := body.GetValue<string>('status', 'A');
    outroDocumento.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (outroDocumento.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (outroDocumento.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (outroDocumento.tipoDocumento.id > 0) then
    begin
      erros.Add('O Codigo do tipo de documento deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (outroDocumento.status <> 'A') and (outroDocumento.status <> 'I') then
    begin
      erros.Add('O Status da cidade informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      outroDocumentoConsultado := outroDocumento.consultarChave();

      if not (Assigned(outroDocumentoConsultado)) then
      begin
        erros.Add('Nenhum outro documento encontrado com o codigo [' + IntToStrSenaoZero(outroDocumento.id) + '] para essa pessoa!');
      end
      else
      begin
        outroDocumentoConsultado.Destroy;
        outroDocumentoConsultado := outroDocumento.existeRegistro();

        if (Assigned(outroDocumentoConsultado)) then
        begin
          erros.Add('Já existe um outro documento [' + IntToStrSenaoZero(outroDocumentoConsultado.id) +
                  ' - ' + outroDocumentoConsultado.documento +
                  ' - ' + outroDocumentoConsultado.status + '] com esse mesmo documento para esse cadastro!');
          outroDocumentoConsultado.Destroy;
        end;
      end;

      outroDocumentoConsultado := TOutroDocumento.Create;
      outroDocumentoConsultado.tipoDocumento.Destroy;
      outroDocumentoConsultado.tipoDocumento := outroDocumento.tipoDocumento.consultarChave();

      if not (Assigned(outroDocumentoConsultado.tipoDocumento)) then
      begin
        erros.Add('Nenhum Tipo de Documento encontrado com o codigo [' + IntToStrSenaoZero(outroDocumento.tipoDocumento.id) + ']!');
      end
      else if (Length(Trim(soNumeros(outroDocumento.documento))) <> outroDocumentoConsultado.tipoDocumento.qtdeCaracteres) then
      begin
        erros.Add('O Numero do documento é invalido, deve conter ' + IntToStrSenaoZero(outroDocumentoConsultado.tipoDocumento.qtdeCaracteres) + ' numericos e validos!');
      end
      else
      begin
        outroDocumentoConsultado.pessoa.Destroy;
        outroDocumentoConsultado.pessoa := outroDocumento.pessoa.consultarChaveSemTipo();

        if not (Assigned(outroDocumentoConsultado.pessoa)) then
        begin
          erros.Add('Nenhum Pessoa encontrado com o codigo [' + IntToStrSenaoZero(outroDocumento.pessoa.id) + ']!');
        end;
      end;

      outroDocumentoConsultado.Destroy;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('OUTRODOCUMENTO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      outroDocumentoConsultado := outroDocumento.alterarOutroDocumento();

      if Assigned(outroDocumentoConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Outro Documento');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(outroDocumento.registrosAfetados));
        montarOutroDocumento(outroDocumentoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        outroDocumentoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Outro Documento!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Outro Documento!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  outroDocumento.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarOutroDocumento(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  outroDocumentoConsultado: TOutroDocumento;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogOutroDocumento(Req, Res, 'inativarOutroDocumento', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    outroDocumento.id := strToIntZero(Req.Params['id']);
    outroDocumento.pessoa.id := strToIntZero(Req.Params['pessoa']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (outroDocumento.pessoa.id > 0) then
    begin
      erros.Add('O Codigo da pessoa deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (outroDocumento.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      outroDocumentoConsultado := outroDocumento.consultarChave();

      if not (Assigned(outroDocumentoConsultado)) then
      begin
        erros.Add('Nenhuma outro documento encontrado com o codigo [' + IntToStrSenaoZero(outroDocumento.id) + '] para essa pessoa!');
      end
      else
      begin
        outroDocumentoConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('OUTRODOCUMENTO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      outroDocumentoConsultado := outroDocumento.inativarOutroDocumento();

      if Assigned(outroDocumentoConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de outro Documento');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(outroDocumento.registrosAfetados));
        montarOutroDocumento(outroDocumentoConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        outroDocumentoConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um outro documento!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um outro documento!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('OUTRODOCUMENTO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  outroDocumento.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/outroDocumento/:pessoa', buscarOutrosDocumentos);
  THorse.Post('/outroDocumento', cadastrarOutroDocumento);
  THorse.Put('/outroDocumento/:pessoa/:id', alterarOutroDocumento);
  THorse.Delete('/outroDocumento/:pessoa/:id', inativarOutroDocumento);
end;

end.
