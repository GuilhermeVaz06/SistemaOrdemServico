object FContato: TFContato
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Cadastro de Contatos'
  ClientHeight = 268
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 447
    Height = 233
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label22: TLabel
      Left = 9
      Top = 139
      Width = 67
      Height = 16
      Caption = 'Observa'#231#227'o'
    end
    object Label1: TLabel
      Left = 315
      Top = 2
      Width = 96
      Height = 16
      Caption = 'Data Nascimento'
    end
    object Label3: TLabel
      Left = 9
      Top = 49
      Width = 33
      Height = 16
      Caption = 'Nome'
    end
    object Label4: TLabel
      Left = 9
      Top = 95
      Width = 41
      Height = 16
      Caption = 'Fun'#231#227'o'
    end
    object Label5: TLabel
      Left = 139
      Top = 95
      Width = 50
      Height = 16
      Caption = 'Telefone'
    end
    object Label6: TLabel
      Left = 269
      Top = 95
      Width = 35
      Height = 16
      Caption = 'E-Mail'
    end
    object Label2: TLabel
      Left = 8
      Top = 3
      Width = 64
      Height = 16
      Caption = 'Documento'
    end
    object Label11: TLabel
      Left = 127
      Top = 3
      Width = 82
      Height = 16
      Caption = 'N'#186' Documento'
    end
    object DBMemo1: TDBMemo
      Left = 9
      Top = 158
      Width = 430
      Height = 53
      DataField = 'observacao'
      DataSource = FDMPessoa.DContato
      TabOrder = 7
    end
    object CBAtivo: TDBCheckBox
      Left = 0
      Top = 216
      Width = 447
      Height = 17
      Align = alBottom
      Caption = 'Ativo'
      DataField = 'status'
      DataSource = FDMPessoa.DContato
      TabOrder = 8
      ValueChecked = 'A'
      ValueUnchecked = 'I'
    end
    object DBEdit3: TDBEdit
      Left = 9
      Top = 66
      Width = 430
      Height = 24
      DataField = 'nome'
      DataSource = FDMPessoa.DContato
      TabOrder = 3
    end
    object DBEdit4: TDBEdit
      Left = 9
      Top = 112
      Width = 124
      Height = 24
      DataField = 'funcao'
      DataSource = FDMPessoa.DContato
      TabOrder = 4
    end
    object DBEdit5: TDBEdit
      Left = 139
      Top = 112
      Width = 124
      Height = 24
      DataField = 'telefone'
      DataSource = FDMPessoa.DContato
      TabOrder = 5
    end
    object DBEdit6: TDBEdit
      Left = 269
      Top = 112
      Width = 170
      Height = 24
      DataField = 'email'
      DataSource = FDMPessoa.DContato
      TabOrder = 6
    end
    object DBDocumento: TDBEdit
      Left = 126
      Top = 19
      Width = 183
      Height = 24
      DataField = 'documento'
      DataSource = FDMPessoa.DContato
      TabOrder = 1
      OnExit = DBDocumentoExit
    end
    object DBLookupComboBox1: TDBLookupComboBox
      Left = 9
      Top = 19
      Width = 111
      Height = 24
      DataField = 'codigoTipoDocumento'
      DataSource = FDMPessoa.DContato
      KeyField = 'codigo'
      ListField = 'descricao'
      ListSource = FDMPessoa.DTipoDocumento
      TabOrder = 0
      OnExit = DBLookupComboBox1Exit
    end
    object EDTNascimento: TDateTimePicker
      Left = 315
      Top = 19
      Width = 124
      Height = 24
      Date = 44975.000000000000000000
      Time = 0.918185462964174800
      TabOrder = 2
      OnChange = EDTNascimentoChange
    end
  end
  object Painel: TPanel
    Left = 0
    Top = 233
    Width = 447
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
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
