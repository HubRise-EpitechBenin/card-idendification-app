from django.shortcuts import render
from rest_framework.response import Response
from visitors.tools.card_model_detector import CardModelDetector
from visitors.tools.filemanager import Filemanager
from visitors.serializers import VisitorCardScanSerializer, VisitorCrudSerializer, VisitCrudSerializer
from rest_framework import generics, status, views
from rest_framework.parsers import FormParser, MultiPartParser, JSONParser, FileUploadParser
from django.conf import settings
from visitors.models import Visitor, Visit
from PIL import Image
import os, uuid

class ApiScanView(generics.GenericAPIView):
    serializer_class = VisitorCardScanSerializer
    parser_classes = (JSONParser, FormParser, MultiPartParser, FileUploadParser)

    def post(self, request):
        try:
            img = request.FILES.get('card_image')
            if img is None:
                return Response({'error': 'No image file attached'}, status=status.HTTP_400_BAD_REQUEST)
        except KeyError:
            return Response({'error': 'No resource file attached'}, status=status.HTTP_400_BAD_REQUEST)
        img_extension = os.path.splitext(img.name)[1]
        save_path = "temp/" + str(uuid.uuid4())
        while os.path.exists(save_path):
            save_path = "temp/" + str(uuid.uuid4())
        os.mkdir(save_path)
        img_save_path = "%s/%s%s" % (save_path, "card", img_extension)
        with open(img_save_path, "wb+") as f:
            for chunk in img.chunks():
                f.write(chunk)
        core = CardModelDetector(settings.PYTESSERACT_LANGUAGE)
        core.detect_card_model(img_save_path)
        visitor = core.validate()
        if not visitor:
            return Response({'error': 'Unable to find card model while creating visitor'}, status=status.HTTP_400_BAD_REQUEST)
        print(visitor)
        if not Visitor.objects.filter(username=visitor['username']).exists():
            serializer = self.serializer_class(data=request.data)
            serializer.is_valid(raise_exception=True)
            save_image = Image.open(img_save_path)
            save_card = save_image.convert('RGB')
            save_folder = "media/" + visitor['username']
            os.mkdir(save_folder)
            save_card_path = "media/" + visitor['username'] + "/card.pdf"
            save_card.save(save_card_path)
            visitor['card_image'] = settings.BACKEND_URL + save_card_path
            serializer.save(**visitor)
            Filemanager.expunge_folder_datas('temp/')
            return Response(visitor, status=status.HTTP_201_CREATED)
        else:
            Filemanager.expunge_folder_datas('temp/')
            return Response({"msg": f"The visitor {visitor['username']} started a new visit"}, status=status.HTTP_200_OK)

    def post4(self, request):
        try:
            img = request.data['card_image']
        except KeyError:
            return Response({'error': 'No resource file attached'}, status=status.HTTP_400_BAD_REQUEST)
        img_extension = os.path.splitext(img.name)[1]
        save_path = "temp/" + str(uuid.uuid4())
        while os.path.exists(save_path):
            save_path = "temp/" + str(uuid.uuid4())
        os.mkdir(save_path)
        img_save_path = "%s/%s%s" % (save_path, "card", img_extension)
        with open(img_save_path, "wb+") as f:
                for chunk in img.chunks():
                    f.write(chunk)
        core = CardModelDetector(settings.PYTESSERACT_LANGUAGE)
        core.detect_card_model(img_save_path)
        visitor = core.validate()
        if not visitor:
            return Response({'error': 'Unable to find card model while creating visitor'}, status=status.HTTP_400_BAD_REQUEST)
        print(visitor)
        if not Visitor.objects.filter(username=visitor['username']).exists():
            serializer = self.serializer_class(data=request.data)
            serializer.is_valid(raise_exception=True)
            save_image = Image.open(img_save_path)
            save_card = save_image.convert('RGB')
            save_folder = "media/" + visitor['username']
            os.mkdir(save_folder)
            save_card_path = "media/" + visitor['username'] + "/card.pdf"
            save_card.save(save_card_path)
            visitor['card_image'] = settings.BACKEND_URL + save_card_path
            serializer.save(**visitor)
            Filemanager.expunge_folder_datas('temp/')
            return Response(visitor, status=status.HTTP_201_CREATED)
        else:
            Filemanager.expunge_folder_datas('temp/')
            return Response({"msg": f"The visitor {visitor['username']} started a new visit"}, status=status.HTTP_200_OK)


class VisitorList(generics.ListCreateAPIView):
    serializer_class = VisitorCrudSerializer
    queryset = Visitor.objects.all()

    def perform_create(self, serializer):
        return serializer.save()

    def get_queryset(self):
        return self.queryset.filter()


class VisitorDetail(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = VisitorCrudSerializer
    queryset = Visitor.objects.all()
    lookup_field = "username"

    def perform_create(self, serializer):
        return serializer.save()

    def get_queryset(self):
        return self.queryset.filter()


class VisitList(generics.ListCreateAPIView):
    serializer_class = VisitCrudSerializer
    queryset = Visit.objects.all()

    def perform_create(self, serializer):
        return serializer.save()

    def get_queryset(self):
        return self.queryset.filter()


class VisitDetail(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = VisitCrudSerializer
    queryset = Visit.objects.all()
    lookup_field = "id"

    def perform_create(self, serializer):
        return serializer.save()

    def get_queryset(self):
        return self.queryset.filter()