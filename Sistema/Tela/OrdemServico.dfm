object FOrdemServico: TFOrdemServico
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastro de Cliente'
  ClientHeight = 614
  ClientWidth = 1363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PCTela: TPageControl
    Left = 0
    Top = 0
    Width = 1363
    Height = 614
    ActivePage = TBConsulta
    Align = alClient
    TabOrder = 0
    object TBCadastro: TTabSheet
      Caption = 'Cadastro'
      OnShow = TBCadastroShow
      object Painel: TPanel
        Left = 0
        Top = 0
        Width = 1355
        Height = 29
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object BFechar: TSpeedButton
          Left = 627
          Top = 0
          Width = 96
          Height = 29
          Align = alLeft
          Caption = 'Fechar'
          ImageIndex = 6
          Images = FMenuPrincipal.ImageList1
          OnClick = BFecharClick
          ExplicitLeft = 640
          ExplicitTop = -4
          ExplicitHeight = 39
        end
        object BConfirmar: TSpeedButton
          Left = 531
          Top = 0
          Width = 96
          Height = 29
          Align = alLeft
          Caption = 'Confirmar'
          ImageIndex = 5
          Images = FMenuPrincipal.ImageList1
          Enabled = False
          OnClick = BConfirmarClick
          ExplicitLeft = 615
          ExplicitTop = -4
          ExplicitHeight = 39
        end
        object BCancelar: TSpeedButton
          Left = 435
          Top = 0
          Width = 96
          Height = 29
          Align = alLeft
          Caption = 'Cancelar'
          ImageIndex = 4
          Images = FMenuPrincipal.ImageList1
          Enabled = False
          OnClick = BCancelarClick
          ExplicitLeft = 519
          ExplicitTop = -4
          ExplicitHeight = 39
        end
        object BInativar: TSpeedButton
          Left = 339
          Top = 0
          Width = 96
          Height = 29
          Align = alLeft
          Caption = 'Inativar'
          ImageIndex = 2
          Images = FMenuPrincipal.ImageList1
          ExplicitLeft = 327
          ExplicitTop = -4
          ExplicitHeight = 39
        end
        object BAlterar: TSpeedButton
          Left = 243
          Top = 0
          Width = 96
          Height = 29
          Align = alLeft
          Caption = 'Alterar'
          ImageIndex = 1
          Images = FMenuPrincipal.ImageList1
          OnClick = BAlterarClick
          ExplicitLeft = 135
          ExplicitTop = -4
          ExplicitHeight = 39
        end
        object BCadastrar: TSpeedButton
          Left = 147
          Top = 0
          Width = 96
          Height = 29
          Align = alLeft
          Caption = 'Cadastrar'
          ImageIndex = 0
          Images = FMenuPrincipal.ImageList1
          OnClick = BCadastrarClick
          ExplicitLeft = 1
          ExplicitTop = -1
          ExplicitHeight = 39
        end
        object DBNavigator1: TDBNavigator
          Left = 0
          Top = 0
          Width = 147
          Height = 29
          DataSource = FDMPessoa.DPessoa
          VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
          Align = alLeft
          TabOrder = 0
        end
      end
      object PInfo: TPanel
        Left = 0
        Top = 513
        Width = 1355
        Height = 53
        Align = alBottom
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 3
        object Label4: TLabel
          Left = 9
          Top = 3
          Width = 88
          Height = 16
          Caption = 'Cadastrado Por'
        end
        object Label5: TLabel
          Left = 199
          Top = 3
          Width = 71
          Height = 16
          Caption = 'Alterado Por'
        end
        object Label6: TLabel
          Left = 388
          Top = 3
          Width = 81
          Height = 16
          Caption = 'Data Cadastro'
        end
        object Label7: TLabel
          Left = 578
          Top = 3
          Width = 84
          Height = 16
          Caption = 'Data Altera'#231#227'o'
        end
        object ECadastradoPor: TDBEdit
          Left = 9
          Top = 20
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'cadastradoPor'
          DataSource = FDMPessoa.DPessoa
          ReadOnly = True
          TabOrder = 0
        end
        object EAlteradoPor: TDBEdit
          Left = 199
          Top = 20
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'alteradoPor'
          DataSource = FDMPessoa.DPessoa
          ReadOnly = True
          TabOrder = 1
        end
        object EDataCadastro: TDBEdit
          Left = 388
          Top = 20
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'dataCadastro'
          DataSource = FDMPessoa.DPessoa
          ReadOnly = True
          TabOrder = 2
        end
        object EDataAlteracao: TDBEdit
          Left = 578
          Top = 20
          Width = 184
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'dataAlteracao'
          DataSource = FDMPessoa.DPessoa
          ReadOnly = True
          TabOrder = 3
        end
      end
      object CBAtivo: TDBCheckBox
        Left = 0
        Top = 566
        Width = 1355
        Height = 17
        Align = alBottom
        Caption = 'Ativo'
        DataField = 'status'
        DataSource = FDMPessoa.DPessoa
        Enabled = False
        TabOrder = 4
        ValueChecked = 'A'
        ValueUnchecked = 'I'
      end
      object PCDados: TPageControl
        Left = 0
        Top = 161
        Width = 1355
        Height = 352
        ActivePage = TBOutrosDocumentos
        Align = alClient
        TabOrder = 2
        ExplicitTop = 201
        ExplicitHeight = 312
        object TBOutrosDocumentos: TTabSheet
          Caption = 'Outros Documentos'
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BCadastrarDocumento: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BRemoverDocumento: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object CBInativoOutroDocumento: TCheckBox
            Left = 0
            Top = 304
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 1
            ExplicitTop = 264
          end
          object GDocumento: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 275
            Align = alClient
            DataSource = FDMPessoa.DOutroDocumento
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 2
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
        end
        object TBEndereco: TTabSheet
          Caption = 'Endere'#231'o'
          ImageIndex = 1
          object Panel1: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BCadastrarEndereco: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BExcluirEndereco: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object CBInativoEndereco: TCheckBox
            Left = 0
            Top = 304
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 1
            ExplicitTop = 264
          end
          object GEndereco: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 275
            Align = alClient
            DataSource = FDMPessoa.DEndereco
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 2
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
        end
        object TBContato: TTabSheet
          Caption = 'Outros Contatos'
          ImageIndex = 2
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 1347
            Height = 29
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object BCadastrarContato: TSpeedButton
              Left = 0
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Cadastrar'
              ImageIndex = 0
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              ExplicitLeft = 8
              ExplicitHeight = 41
            end
            object BExcluirContato: TSpeedButton
              Left = 96
              Top = 0
              Width = 96
              Height = 29
              Align = alLeft
              Caption = 'Excluir'
              ImageIndex = 3
              Images = FMenuPrincipal.ImageList1
              Enabled = False
              ExplicitLeft = 1
              ExplicitTop = -1
              ExplicitHeight = 39
            end
          end
          object CBInativoContato: TCheckBox
            Left = 0
            Top = 304
            Width = 1347
            Height = 17
            Align = alBottom
            Caption = 'Mostrar Inativos'
            Enabled = False
            TabOrder = 1
            ExplicitTop = 264
          end
          object GContato: TDBGrid
            Left = 0
            Top = 29
            Width = 1347
            Height = 275
            Align = alClient
            DataSource = FDMPessoa.DContato
            Enabled = False
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
            ReadOnly = True
            TabOrder = 2
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -13
            TitleFont.Name = 'Tahoma'
            TitleFont.Style = []
            OnDrawColumnCell = GDadosDrawColumnCell
            OnTitleClick = GDadosTitleClick
            Columns = <
              item
                Expanded = False
                FieldName = 'codigo'
                Title.Alignment = taCenter
                Title.Caption = 'Codigo'
                Width = 65
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'email'
                Title.Alignment = taCenter
                Title.Caption = 'Email'
                Width = 100
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'cadastradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Cadastrado Por'
                Width = 143
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'alteradoPor'
                Title.Alignment = taCenter
                Title.Caption = 'Alterado Por'
                Width = 130
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataCadastro'
                Title.Alignment = taCenter
                Title.Caption = 'Data Cadastro'
                Width = 134
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'dataAlteracao'
                Title.Alignment = taCenter
                Title.Caption = 'Data Altera'#231#227'o'
                Width = 153
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'status'
                Title.Alignment = taCenter
                Title.Caption = 'Status'
                Width = 61
                Visible = True
              end>
          end
        end
      end
      object PDados: TPanel
        Left = 0
        Top = 29
        Width = 1355
        Height = 132
        Align = alTop
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 1
        object Label1: TLabel
          Left = 9
          Top = 1
          Width = 39
          Height = 16
          Caption = 'Codigo'
        end
        object Label2: TLabel
          Left = 90
          Top = 1
          Width = 64
          Height = 16
          Caption = 'Documento'
        end
        object Label13: TLabel
          Left = 388
          Top = 1
          Width = 67
          Height = 16
          Caption = 'Observa'#231#227'o'
        end
        object ECodigo: TDBEdit
          Left = 9
          Top = 17
          Width = 76
          Height = 24
          TabStop = False
          Color = clBtnFace
          DataField = 'codigo'
          DataSource = FDMPessoa.DPessoa
          ReadOnly = True
          TabOrder = 0
        end
        object DBLDocumento: TDBLookupComboBox
          Left = 91
          Top = 17
          Width = 102
          Height = 24
          DataField = 'codigoTipoDocumento'
          DataSource = FDMPessoa.DPessoa
          KeyField = 'codigo'
          ListField = 'descricao'
          ListSource = FDMPessoa.DTipoDocumento
          TabOrder = 1
        end
        object DBMemo1: TDBMemo
          Left = 389
          Top = 17
          Width = 373
          Height = 108
          DataField = 'observacao'
          DataSource = FDMPessoa.DPessoa
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
    object TBConsulta: TTabSheet
      Caption = 'Consulta'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 1355
        Height = 52
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object BConsultar: TSpeedButton
          Left = 383
          Top = 12
          Width = 96
          Height = 30
          Caption = 'Consultar'
          ImageIndex = 7
          Images = FMenuPrincipal.ImageList1
          OnClick = BConsultarClick
        end
        object LConsultaRazaoSocial: TLabel
          Left = 3
          Top = 0
          Width = 73
          Height = 16
          Caption = 'Raz'#227'o Social'
        end
        object SpeedButton1: TSpeedButton
          Left = 479
          Top = 12
          Width = 96
          Height = 30
          Caption = 'Fechar'
          ImageIndex = 6
          Images = FMenuPrincipal.ImageList1
          OnClick = BFecharClick
        end
        object ERazaoSocial: TEdit
          Left = 3
          Top = 18
          Width = 184
          Height = 24
          TabOrder = 0
        end
      end
      object GDados: TDBGrid
        Left = 0
        Top = 52
        Width = 1355
        Height = 514
        Align = alClient
        DataSource = FDMPessoa.DPessoa
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = GDadosDrawColumnCell
        OnDblClick = GDadosDblClick
        OnTitleClick = GDadosTitleClick
        Columns = <
          item
            Expanded = False
            FieldName = 'codigo'
            Title.Alignment = taCenter
            Title.Caption = 'Codigo'
            Width = 65
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cadastradoPor'
            Title.Alignment = taCenter
            Title.Caption = 'Cadastrado Por'
            Width = 143
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alteradoPor'
            Title.Alignment = taCenter
            Title.Caption = 'Alterado Por'
            Width = 152
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataCadastro'
            Title.Alignment = taCenter
            Title.Caption = 'Data Cadastro'
            Width = 154
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dataAlteracao'
            Title.Alignment = taCenter
            Title.Caption = 'Data Altera'#231#227'o'
            Width = 153
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'status'
            Title.Alignment = taCenter
            Title.Caption = 'Status'
            Width = 61
            Visible = True
          end>
      end
      object CBMostrarInativo: TCheckBox
        Left = 0
        Top = 566
        Width = 1355
        Height = 17
        Align = alBottom
        Caption = 'Mostrar Inativos'
        TabOrder = 2
      end
    end
  end
end
