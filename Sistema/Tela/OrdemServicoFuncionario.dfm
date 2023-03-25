object FOrdemServicoFuncionario: TFOrdemServicoFuncionario
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastrar Custo de Funcionario'
  ClientHeight = 367
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 501
    Height = 330
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label3: TLabel
      Left = 103
      Top = 2
      Width = 55
      Height = 16
      Caption = 'Descri'#231#227'o'
    end
    object Label1: TLabel
      Left = 9
      Top = 87
      Width = 103
      Height = 16
      Caption = 'Qtde Hora Normal'
    end
    object Label2: TLabel
      Left = 165
      Top = 87
      Width = 106
      Height = 16
      Caption = 'Valor Hora Normal'
    end
    object Label4: TLabel
      Left = 320
      Top = 87
      Width = 139
      Height = 16
      Caption = 'Valor Total Hora Normal'
    end
    object Label5: TLabel
      Left = 9
      Top = 2
      Width = 41
      Height = 16
      Caption = 'Fun'#231#227'o'
    end
    object Label6: TLabel
      Left = 103
      Top = 45
      Width = 33
      Height = 16
      Caption = 'Nome'
    end
    object Label7: TLabel
      Left = 9
      Top = 44
      Width = 66
      Height = 16
      Caption = 'Funcionario'
    end
    object Label8: TLabel
      Left = 9
      Top = 134
      Width = 88
      Height = 16
      Caption = 'Qtde Hora 50%'
    end
    object Label9: TLabel
      Left = 165
      Top = 134
      Width = 91
      Height = 16
      Caption = 'Valor Hora 50%'
    end
    object Label10: TLabel
      Left = 320
      Top = 134
      Width = 124
      Height = 16
      Caption = 'Valor Total Hora 50%'
    end
    object Label11: TLabel
      Left = 320
      Top = 179
      Width = 131
      Height = 16
      Caption = 'Valor Total Hora 100%'
    end
    object Label12: TLabel
      Left = 165
      Top = 179
      Width = 98
      Height = 16
      Caption = 'Valor Hora 100%'
    end
    object Label13: TLabel
      Left = 9
      Top = 179
      Width = 95
      Height = 16
      Caption = 'Qtde Hora 100%'
    end
    object Label14: TLabel
      Left = 320
      Top = 223
      Width = 166
      Height = 16
      Caption = 'Valor Total Hora Ad. Noturno'
    end
    object Label15: TLabel
      Left = 165
      Top = 223
      Width = 133
      Height = 16
      Caption = 'Valor Hora Ad. Noturno'
    end
    object Label16: TLabel
      Left = 9
      Top = 223
      Width = 130
      Height = 16
      Caption = 'Qtde Hora Ad. Noturno'
    end
    object Label17: TLabel
      Left = 9
      Top = 267
      Width = 66
      Height = 16
      Caption = 'Valor Final'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBDocumento: TDBEdit
      Left = 103
      Top = 19
      Width = 390
      Height = 24
      TabStop = False
      DataField = 'descricao'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 1
    end
    object CBAtivo: TDBCheckBox
      Left = 0
      Top = 313
      Width = 501
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 17
      ValueChecked = 'A'
      ValueUnchecked = 'I'
      ExplicitTop = 48
      ExplicitWidth = 758
    end
    object DBEdit1: TDBEdit
      Left = 9
      Top = 104
      Width = 149
      Height = 24
      DataField = 'qtdeHoraNormal'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 4
      OnExit = DBEdit1Exit
    end
    object DBEdit2: TDBEdit
      Left = 165
      Top = 104
      Width = 149
      Height = 24
      DataField = 'valorHoraNormal'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 5
      OnExit = DBEdit1Exit
    end
    object DBEdit3: TDBEdit
      Left = 320
      Top = 104
      Width = 173
      Height = 24
      TabStop = False
      DataField = 'valorTotalNormal'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 6
      OnExit = DBEdit1Exit
    end
    object DBFuncao: TDBEdit
      Left = 9
      Top = 19
      Width = 88
      Height = 24
      TabStop = False
      DataField = 'codigoFuncao'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 0
      OnDblClick = DBFuncaoDblClick
      OnExit = DBFuncaoExit
    end
    object DBEdit4: TDBEdit
      Left = 103
      Top = 61
      Width = 390
      Height = 24
      TabStop = False
      DataField = 'nomeFuncionario'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 3
    end
    object DBFuncionario: TDBEdit
      Left = 9
      Top = 61
      Width = 88
      Height = 24
      DataField = 'codigoFuncionario'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 2
      OnDblClick = DBFuncionarioDblClick
      OnExit = DBFuncionarioExit
    end
    object DBEdit6: TDBEdit
      Left = 9
      Top = 151
      Width = 149
      Height = 24
      DataField = 'qtdeHora50'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 7
      OnExit = DBEdit1Exit
    end
    object DBEdit7: TDBEdit
      Left = 165
      Top = 151
      Width = 149
      Height = 24
      TabStop = False
      DataField = 'valorHora50'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 8
      OnExit = DBEdit1Exit
    end
    object DBEdit8: TDBEdit
      Left = 320
      Top = 151
      Width = 173
      Height = 24
      TabStop = False
      DataField = 'valorTotal50'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 9
      OnExit = DBEdit1Exit
    end
    object DBEdit9: TDBEdit
      Left = 9
      Top = 196
      Width = 149
      Height = 24
      DataField = 'qtdeHora100'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 10
      OnExit = DBEdit1Exit
    end
    object DBEdit10: TDBEdit
      Left = 320
      Top = 196
      Width = 173
      Height = 24
      TabStop = False
      DataField = 'valorTotal100'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 12
      OnExit = DBEdit1Exit
    end
    object DBEdit11: TDBEdit
      Left = 165
      Top = 196
      Width = 149
      Height = 24
      TabStop = False
      DataField = 'valorHora100'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 11
      OnExit = DBEdit1Exit
    end
    object DBEdit12: TDBEdit
      Left = 9
      Top = 240
      Width = 149
      Height = 24
      DataField = 'qtdeHoraAdNoturno'
      DataSource = FDMOrdemServico.DFuncionario
      TabOrder = 13
      OnExit = DBEdit1Exit
    end
    object DBEdit13: TDBEdit
      Left = 320
      Top = 240
      Width = 173
      Height = 24
      TabStop = False
      DataField = 'valorTotalAdNoturno'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 15
      OnExit = DBEdit1Exit
    end
    object DBEdit14: TDBEdit
      Left = 165
      Top = 240
      Width = 149
      Height = 24
      TabStop = False
      DataField = 'valorHoraAdNoturno'
      DataSource = FDMOrdemServico.DFuncionario
      ReadOnly = True
      TabOrder = 14
      OnExit = DBEdit1Exit
    end
    object DBEdit5: TDBEdit
      Left = 9
      Top = 284
      Width = 149
      Height = 24
      TabStop = False
      DataField = 'valorTotal'
      DataSource = FDMOrdemServico.DFuncionario
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 16
      OnExit = DBEdit1Exit
    end
  end
  object Painel: TPanel
    Left = 0
    Top = 330
    Width = 501
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 65
    ExplicitWidth = 758
    object BConfirmar: TSpeedButton
      Left = 405
      Top = 0
      Width = 96
      Height = 34
      Align = alRight
      Caption = 'Confirmar'
      ImageIndex = 5
      Images = FMenuPrincipal.ImageList1
      OnClick = BConfirmarClick
      ExplicitLeft = 478
      ExplicitTop = -1
    end
    object BCancelar: TSpeedButton
      Left = 0
      Top = 0
      Width = 96
      Height = 34
      Align = alLeft
      Caption = 'Cancelar'
      ImageIndex = 4
      Images = FMenuPrincipal.ImageList1
      OnClick = BCancelarClick
      ExplicitLeft = 1
      ExplicitTop = -1
      ExplicitHeight = 39
    end
  end
end
