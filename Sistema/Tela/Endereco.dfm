object FEndereco: TFEndereco
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastro de Endere'#231'os'
  ClientHeight = 357
  ClientWidth = 447
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
    Width = 447
    Height = 320
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 9
      Top = 2
      Width = 55
      Height = 16
      Caption = 'Descri'#231#227'o'
    end
    object Label22: TLabel
      Left = 9
      Top = 227
      Width = 67
      Height = 16
      Caption = 'Observa'#231#227'o'
    end
    object Label1: TLabel
      Left = 315
      Top = 2
      Width = 22
      Height = 16
      Caption = 'CEP'
    end
    object Label3: TLabel
      Left = 9
      Top = 49
      Width = 72
      Height = 16
      Caption = 'Longradouro'
    end
    object Label4: TLabel
      Left = 9
      Top = 95
      Width = 45
      Height = 16
      Caption = 'Numero'
    end
    object Label5: TLabel
      Left = 139
      Top = 95
      Width = 34
      Height = 16
      Caption = 'Bairro'
    end
    object Label6: TLabel
      Left = 269
      Top = 95
      Width = 79
      Height = 16
      Caption = 'Complemento'
    end
    object Label7: TLabel
      Left = 9
      Top = 141
      Width = 39
      Height = 16
      Caption = 'Cidade'
    end
    object Label8: TLabel
      Left = 269
      Top = 141
      Width = 38
      Height = 16
      Caption = 'Estado'
    end
    object Label9: TLabel
      Left = 9
      Top = 185
      Width = 23
      Height = 16
      Caption = 'Pa'#237's'
    end
    object Label10: TLabel
      Left = 269
      Top = 185
      Width = 82
      Height = 16
      Caption = 'Tipo Endere'#231'o'
    end
    object DBMemo1: TDBMemo
      Left = 9
      Top = 246
      Width = 430
      Height = 53
      DataField = 'observacao'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 12
    end
    object CBAtivo: TDBCheckBox
      Left = 0
      Top = 303
      Width = 447
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 13
      ValueChecked = 'A'
      ValueUnchecked = 'I'
      ExplicitTop = 125
      ExplicitWidth = 550
    end
    object DBEdit1: TDBEdit
      Left = 102
      Top = 19
      Width = 207
      Height = 24
      TabStop = False
      DataField = 'tipoEndereco'
      DataSource = FDMPessoa.DEndereco
      ReadOnly = True
      TabOrder = 1
    end
    object DBEdit2: TDBEdit
      Left = 315
      Top = 19
      Width = 124
      Height = 24
      DataField = 'cep'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 2
    end
    object DBEdit3: TDBEdit
      Left = 9
      Top = 66
      Width = 430
      Height = 24
      DataField = 'longradouro'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 3
    end
    object DBEdit4: TDBEdit
      Left = 9
      Top = 112
      Width = 124
      Height = 24
      DataField = 'numero'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 4
    end
    object DBEdit5: TDBEdit
      Left = 139
      Top = 112
      Width = 124
      Height = 24
      DataField = 'bairro'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 5
    end
    object DBEdit6: TDBEdit
      Left = 269
      Top = 112
      Width = 170
      Height = 24
      DataField = 'complemento'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 6
    end
    object DBCidade: TDBEdit
      Left = 9
      Top = 158
      Width = 67
      Height = 24
      DataField = 'codigoCidade'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 7
      OnDblClick = DBCidadeDblClick
      OnExit = DBCidadeExit
    end
    object DBEdit8: TDBEdit
      Left = 82
      Top = 158
      Width = 181
      Height = 24
      TabStop = False
      DataField = 'nomeCidade'
      DataSource = FDMPessoa.DEndereco
      ReadOnly = True
      TabOrder = 8
    end
    object DBEdit9: TDBEdit
      Left = 269
      Top = 158
      Width = 170
      Height = 24
      TabStop = False
      DataField = 'nomeEstado'
      DataSource = FDMPessoa.DEndereco
      ReadOnly = True
      TabOrder = 9
    end
    object DBEdit10: TDBEdit
      Left = 9
      Top = 202
      Width = 254
      Height = 24
      TabStop = False
      DataField = 'nomePais'
      DataSource = FDMPessoa.DEndereco
      ReadOnly = True
      TabOrder = 10
    end
    object DBLookupComboBox2: TDBLookupComboBox
      Left = 269
      Top = 202
      Width = 170
      Height = 24
      DataField = 'prioridade'
      DataSource = FDMPessoa.DEndereco
      KeyField = 'codigo'
      ListField = 'descricao'
      ListSource = FDMPessoa.DPrioridade
      TabOrder = 11
    end
    object DBDescricao: TDBEdit
      Left = 9
      Top = 19
      Width = 87
      Height = 24
      DataField = 'codigoTipoEndereco'
      DataSource = FDMPessoa.DEndereco
      TabOrder = 0
      OnDblClick = DBDescricaoDblClick
      OnExit = DBDescricaoExit
    end
  end
  object Painel: TPanel
    Left = 0
    Top = 320
    Width = 447
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 142
    ExplicitWidth = 550
    object BConfirmar: TSpeedButton
      Left = 351
      Top = 0
      Width = 96
      Height = 34
      Align = alRight
      Caption = 'Confirmar'
      ImageIndex = 5
      Images = FMenuPrincipal.ImageList1
      OnClick = BConfirmarClick
      ExplicitLeft = 0
      ExplicitTop = -3
      ExplicitHeight = 29
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
