unit Controller.OrdemServico.Funcionario;

interface

uses Horse, System.SysUtils, Model.OrdemServico.Funcionario, System.JSON, System.Classes,
     Principal, UFuncao;

var
  funcionario: TFuncionario;
  token: string;
  continuar: Boolean;

procedure Registry;
procedure destruirConexao;

implementation

procedure limparVariaveis;
begin
  funcionario.limpar;
  token := '';
end;

procedure montarFuncionario(itemFuncionario: TFuncionario; out resposta: TJSONObject);
begin
  resposta.AddPair('codigo',TJSONNumber.Create(itemfuncionario.id));
  resposta.AddPair('ordem',TJSONNumber.Create(itemfuncionario.ordemServico.id));
  resposta.AddPair('codigoFuncao', TJSONNumber.Create(itemfuncionario.funcao.id));
  resposta.AddPair('descricao', itemfuncionario.funcao.descricao);
  resposta.AddPair('codigoFuncionario', TJSONNumber.Create(itemfuncionario.funcionario.id));
  resposta.AddPair('nomeFuncionario', itemfuncionario.funcionario.razaoSocial);
  resposta.AddPair('qtdeHoraNormal',TJSONNumber.Create(itemfuncionario.qtdeHoraNormal));
  resposta.AddPair('qtdeHora50',TJSONNumber.Create(itemfuncionario.qtdeHora50));
  resposta.AddPair('qtdeHora100',TJSONNumber.Create(itemfuncionario.qtdeHora100));
  resposta.AddPair('qtdeHoraAdNoturno',TJSONNumber.Create(itemfuncionario.qtdeHoraAdNoturno));
  resposta.AddPair('valorHoraNormal',TJSONNumber.Create(itemfuncionario.valorHoraNormal));
  resposta.AddPair('valorHora50',TJSONNumber.Create(itemfuncionario.valorHora50));
  resposta.AddPair('valorHora100',TJSONNumber.Create(itemfuncionario.valorHora100));
  resposta.AddPair('valorHoraAdNoturno',TJSONNumber.Create(itemfuncionario.valorHoraAdNoturno));
  resposta.AddPair('valorTotalNormal',TJSONNumber.Create(itemfuncionario.valorTotalNormal));
  resposta.AddPair('valorTotal50',TJSONNumber.Create(itemfuncionario.valorTotal50));
  resposta.AddPair('valorTotal100',TJSONNumber.Create(itemfuncionario.valorTotal100));
  resposta.AddPair('valorTotalAdNoturno',TJSONNumber.Create(itemfuncionario.valorTotalAdNoturno));
  resposta.AddPair('valorTotal',TJSONNumber.Create(itemfuncionario.valorTotal));
  resposta.AddPair('cadastradoPor',itemfuncionario.cadastradoPor.usuario);
  resposta.AddPair('alteradoPor',itemfuncionario.alteradoPor.usuario);
  resposta.AddPair('dataCadastro',DateTimeToStr(itemfuncionario.dataCadastro));
  resposta.AddPair('dataAlteracao',DateTimeToStr(itemfuncionario.ultimaAlteracao));
  resposta.AddPair('status',itemfuncionario.status);
end;

function gerarLogFuncionario(Req: THorseRequest; Res: THorseResponse; procedimento: string; out resposta: TJSONObject): Integer;
var
  mensagem: string;
begin
  try
    Result := funcionario.GerarLog('Funcionario',
                                procedimento,
                                imprimirRequisicao(req)
    );
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao Gerar Log!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO018', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
      Result := 0;
    end;
  end;
end;

procedure criarConexao;
begin
  try
    funcionario := TFuncionario.Create;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao criar a classe Funcionario');
    end;
  end;
end;

procedure destruirConexao;
begin
  try
    funcionario.Destroy;
  except
    on E: Exception do
    begin
      raise Exception.Create('Erro ao destuir a classe Funcionario');
    end;
  end;
end;

function verificarToken(Res: THorseResponse; out resposta: TJSONObject): Boolean;
var
  mensagem: string;
begin
  Result := True;

  try
    if not (funcionario.verificarToken(token)) then
    begin
      mensagem := 'O token informado é invalido!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO008', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      Result := False;
    end;
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao verificar o token!';
      resposta.Create(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO011', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      Result := False;
    end;
  end;
end;

procedure buscarFuncionarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  resposta, temporario: TJSONObject;
  quantidade, i: integer;
  arrayResposta: TJSONArray;
  funcionarios: TArray<TFuncionario>;
  filtrado: Boolean;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncionario(Req, Res, 'buscarFuncionarios', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    funcionario.id := strToIntZero(Req.Query['codigo']);
    funcionario.status := Req.Query['status'];
    funcionario.limite := strToIntZero(Req.Query['limite']);
    funcionario.offset := strToIntZero(Req.Query['offset']);
    funcionario.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao recuperar informações da requisição!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO010', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if not (funcionario.ordemServico.id > 0) then
  begin
    mensagem := 'O codigo da ordem deve ser informado!';
    resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO019', mensagem))));
    Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    continuar := False;
  end;

  if (funcionario.status = '') then
  begin
    funcionario.status := 'A';
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    if (funcionario.ordemServico.id > 0) or
       (funcionario.id > 0) then
    begin
      filtrado := True;
    end
    else
    begin
      filtrado := False;
    end;

    funcionarios := funcionario.consultar();
    quantidade := Length(funcionarios);

    resposta.AddPair('tipo', 'consulta Funcionarios');
    resposta.AddPair('filtrado', TJSONBool.Create(filtrado));
    resposta.AddPair('maisRegistros', TJSONBool.Create(funcionario.maisRegistro));
    resposta.AddPair('qtdeRegistros', TJSONNumber.Create(quantidade));
    resposta.AddPair('limite', TJSONNumber.Create(funcionario.limite));
    resposta.AddPair('offset', TJSONNumber.Create(funcionario.offset));

    if not Assigned(funcionarios) then
    begin
      if (Length(funcionarios) = 0) then
      begin
        resposta.AddPair(TJSONPair.Create('dados', TJSONArray.Create));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
      end
      else
      begin
        mensagem := 'Erro ao consultar os Funcionarios!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO002', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end
    else
    begin
      arrayResposta := TJSONArray.Create;

      for i := 0 to quantidade - 1 do
      begin
        temporario := TJSONObject.Create;
        montarFuncionario(funcionarios[i], temporario);
        arrayResposta.Add(temporario);
      end;

      resposta.AddPair(TJSONPair.Create('dados', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(200);
    end;

    for i := 0 to quantidade - 1 do
    begin
      funcionarios[i].destroy;
    end;

  except
    on E: Exception do
    begin
      if not (Assigned(arrayResposta)) then
      begin
        arrayResposta := TJSONArray.Create;
      end;

      arrayResposta.Add(UFuncao.JsonErro('FUNCIONARIO003', 'Erro não tratado ao listar todos os Funcionarios!'));
      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcionario.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure cadastrarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  funcionarioConsultado: TFuncionario;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncionario(Req, Res, 'cadastrarFuncionario', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    funcionario.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    funcionario.funcao.id := body.GetValue<Integer>('codigoFuncao', 0);
    funcionario.funcionario.id := body.GetValue<Integer>('codigoFuncionario', 0);
    funcionario.qtdeHoraNormal := body.GetValue<Integer>('qtdeHoraNormal', 0);
    funcionario.qtdeHora50 := body.GetValue<Integer>('qtdeHora50', 0);
    funcionario.qtdeHora100 := body.GetValue<Integer>('qtdeHora100', 0);
    funcionario.qtdeHoraAdNoturno := body.GetValue<Integer>('qtdeHoraAdNoturno', 0);
    funcionario.valorHoraNormal := body.GetValue<Double>('valorHoraNormal', 0);
    funcionario.id := 0;
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO005', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (funcionario.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (funcionario.funcao.id > 0) then
    begin
      erros.Add('A Função deve ser informada!');
    end;

    if (erros.Text = '') then
    begin
      funcionarioConsultado := funcionario.existeRegistro();

      if (Assigned(funcionarioConsultado)) then
      begin
        erros.Add('Já existe um funcionario [' + IntToStrSenaoZero(funcionarioConsultado.id) +
                  ' - ' + funcionarioConsultado.funcao.descricao +
                  ' - ' + funcionarioConsultado.funcionario.razaoSocial +
                  ' - ' + funcionarioConsultado.status + '] com essa mesma descrição para essa ordem!');
        funcionarioConsultado.Destroy;
      end
      else
      begin
        funcionarioConsultado := TFuncionario.Create;
        funcionarioConsultado.ordemServico.Destroy;
        funcionarioConsultado.ordemServico := funcionario.ordemServico.consultarChave();

        if not (Assigned(funcionarioConsultado.ordemServico)) then
        begin
          erros.Add('Nenhuma ordem com o codigo [' + IntToStrSenaoZero(funcionario.ordemServico.id) + ']!');
        end
        else
        begin
          funcionarioConsultado.funcao.Destroy;
          funcionarioConsultado.funcao := funcionario.funcao.consultarChave();

          if not (Assigned(funcionarioConsultado.funcao)) then
          begin
            erros.Add('Nenhuma função com o codigo [' + IntToStrSenaoZero(funcionario.funcao.id) + ']!');
          end
          else if (funcionario.funcionario.id > 0) then
          begin
            funcionarioConsultado.funcionario.Destroy;
            funcionarioConsultado.funcionario := funcionario.funcionario.consultarChave();

            if not (Assigned(funcionarioConsultado.funcionario)) then
            begin
              erros.Add('Nenhum funcionario com o codigo [' + IntToStrSenaoZero(funcionario.funcionario.id) + ']!');
            end;
          end;

          funcionarioConsultado.Destroy;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('FUNCIONARIO006',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      funcionarioConsultado := funcionario.cadastrarFuncionario();

      if Assigned(funcionarioConsultado) then
      begin
        resposta.AddPair('tipo', 'Cadastro de Funcionario');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(funcionario.registrosAfetados));
        montarFuncionario(funcionarioConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        funcionarioConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao cadastrar um Funcionario!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO007', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao cadastrar um Funcionario!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO007', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcionario.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure alterarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  body: TJSONValue;
  arrayResposta: TJSONArray;
  funcionarioConsultado: TFuncionario;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncionario(Req, Res, 'alterarFuncionario', resposta);

  if (continuar) then
  try
    body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

    token := Req.Headers['token'];
    funcionario.ordemServico.id := body.GetValue<Integer>('ordem', 0);
    funcionario.funcao.id := body.GetValue<Integer>('codigoFuncao', 0);
    funcionario.funcionario.id := body.GetValue<Integer>('codigoFuncionario', 0);
    funcionario.qtdeHoraNormal := body.GetValue<Integer>('qtdeHoraNormal', 0);
    funcionario.qtdeHora50 := body.GetValue<Integer>('qtdeHora50', 0);
    funcionario.qtdeHora100 := body.GetValue<Integer>('qtdeHora100', 0);
    funcionario.qtdeHoraAdNoturno := body.GetValue<Integer>('qtdeHoraAdNoturno', 0);
    funcionario.valorHoraNormal := body.GetValue<Double>('valorHoraNormal', 0);
    funcionario.status := body.GetValue<string>('status', 'A');
    funcionario.id := strToIntZero(Req.Params['id']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO012', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  FreeAndNil(body);

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (funcionario.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (funcionario.funcao.id > 0) then
    begin
      erros.Add('A Função deve ser informada!');
    end;

    if (funcionario.status <> 'A') and (funcionario.status <> 'I') then
    begin
      erros.Add('O Status informado é invalido!');
    end;

    if (erros.Text = '') then
    begin
      funcionarioConsultado := funcionario.consultarChave();

      if not (Assigned(funcionarioConsultado)) then
      begin
        erros.Add('Nenhum funcionario encontrado com o codigo [' + IntToStrSenaoZero(funcionario.id) + '] para essa ordem!');
      end
      else
      begin
        funcionarioConsultado.Destroy;
        funcionarioConsultado := funcionario.existeRegistro();

        if (Assigned(funcionarioConsultado)) then
        begin
          erros.Add('Já existe um funcionario [' + IntToStrSenaoZero(funcionarioConsultado.id) +
                  ' - ' + funcionarioConsultado.funcao.descricao +
                  ' - ' + funcionarioConsultado.funcionario.razaoSocial +
                  ' - ' + funcionarioConsultado.status + '] com essa mesma descrição para essa ordem!');
          funcionarioConsultado.Destroy;
        end
        else
        begin
          funcionarioConsultado := TFuncionario.Create;
          funcionarioConsultado.ordemServico.Destroy;
          funcionarioConsultado.ordemServico := funcionario.ordemServico.consultarChave();

          if not (Assigned(funcionarioConsultado.ordemServico)) then
          begin
            erros.Add('Nenhuma ordem com o codigo [' + IntToStrSenaoZero(funcionario.ordemServico.id) + ']!');
          end
          else
          begin
            funcionarioConsultado.funcao.Destroy;
            funcionarioConsultado.funcao := funcionario.funcao.consultarChave();

            if not (Assigned(funcionarioConsultado.funcao)) then
            begin
              erros.Add('Nenhuma função com o codigo [' + IntToStrSenaoZero(funcionario.funcao.id) + ']!');
            end
            else if (funcionario.funcionario.id > 0) then
            begin
              funcionarioConsultado.funcionario.Destroy;
              funcionario.funcionario.tipoPessoa.id := tpFuncionario;
              funcionarioConsultado.funcionario := funcionario.funcionario.consultarChave();

              if not (Assigned(funcionarioConsultado.funcionario)) then
              begin
                erros.Add('Nenhum funcionario com o codigo [' + IntToStrSenaoZero(funcionario.funcionario.id) + ']!');
              end;
            end;

            funcionarioConsultado.Destroy;
          end;
        end;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('FUNCIONARIO013',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      funcionarioConsultado := funcionario.alterarFuncionario();

      if Assigned(funcionarioConsultado) then
      begin
        resposta.AddPair('tipo', 'Alteração de Funcionario');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(funcionario.registrosAfetados));
        montarFuncionario(funcionarioConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        funcionarioConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao alterar um Funcionario!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO014', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao alterar um Funcionario!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO014', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcionario.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure inativarFuncionario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  erros: TStringList;
  resposta: TJSONObject;
  arrayResposta: TJSONArray;
  funcionarioConsultado: TFuncionario;
  i: integer;
  mensagem: string;
  codigoLog: integer;
begin
  continuar := True;
  resposta := TJSONObject.Create;
  codigoLog := gerarLogFuncionario(Req, Res, 'inativarFuncionario', resposta);

  if (continuar) then
  try
    token := Req.Headers['token'];
    funcionario.id := strToIntZero(Req.Params['id']);
    funcionario.ordemServico.id := strToIntZero(Req.Params['ordem']);
  except
    on E: Exception do
    begin
      mensagem := 'Erro ao recuperar dados da requisição: ' + e.Message + '!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO015', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
      continuar := False;
    end;
  end;

  if (continuar) and (verificarToken(res, resposta)) then
  try
    erros := TStringList.Create;
    arrayResposta := TJSONArray.Create;

    if not (funcionario.ordemServico.id > 0) then
    begin
      erros.Add('O Codigo da ordem deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if not (funcionario.id > 0) then
    begin
      erros.Add('O Codigo deve ser informado, ou deve ser um numero inteiro valido!');
    end;

    if (erros.Text = '') then
    begin
      funcionarioConsultado := funcionario.consultarChave();

      if not (Assigned(funcionarioConsultado)) then
      begin
        erros.Add('Nenhum Funcionario encontrado com o codigo [' + IntToStrSenaoZero(funcionario.id) + '] para essa ordem!');
      end
      else
      begin
        funcionarioConsultado.Destroy;
      end;
    end;

    if (erros.Text <> '') then
    begin
      for i := 0 to erros.Count - 1 do
      begin
        arrayResposta.Add(UFuncao.JsonErro('FUNCIONARIO016',  erros[i]));
      end;

      resposta.AddPair(TJSONPair.Create('Erros', arrayResposta));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(401);
    end
    else
    begin
      FreeAndNil(arrayResposta);
      funcionarioConsultado := funcionario.inativarFuncionario();

      if Assigned(funcionarioConsultado) then
      begin
        resposta.AddPair('tipo', 'Exclusão de Funcionario');
        resposta.AddPair('registrosAfetados', TJSONNumber.Create(funcionario.registrosAfetados));
        montarFuncionario(funcionarioConsultado, resposta);
        Res.Send<TJSONAncestor>(resposta.Clone).Status(200);

        funcionarioConsultado.Destroy;
      end
      else
      begin
        mensagem := 'Erro não tratado ao inativar um Funcionario!';
        resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO017', mensagem))));
        Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
      end;
    end;

    FreeAndNil(erros);
  except
    on E: Exception do
    begin
      mensagem := 'Erro não tratado ao inativar um Funcionario!';
      resposta.AddPair(TJSONPair.Create('Erros', TJSONArray.Create(UFuncao.JsonErro('FUNCIONARIO017', mensagem))));
      Res.Send<TJSONAncestor>(resposta.Clone).Status(500);
    end;
  end;

  funcionario.atualizarLog(codigoLog, Res.Status, imprimirResposta(Res.Status, resposta));
  limparVariaveis;
  FreeAndNil(resposta);
end;

procedure Registry;
begin
  criarConexao;
  THorse.Get('/ordemServicoFuncionario/:ordem', buscarFuncionarios);
  THorse.Post('/ordemServicoFuncionario', cadastrarFuncionario);
  THorse.Put('/ordemServicoFuncionario/:ordem/:id', alterarFuncionario);
  THorse.Delete('/ordemServicoFuncionario/:ordem/:id', inativarFuncionario);
end;

end.
