from rest_framework import serializers
from visitors.models import Visitor, Visit
import random


class VisitorCardScanSerializer(serializers.ModelSerializer):
    card_image = serializers.CharField(max_length=555, read_only=True)
    last_name = serializers.CharField(max_length=128, read_only=True)
    first_names = serializers.CharField(max_length=555, read_only=True)
    class Meta:
        model = Visitor
        fields=['last_name', 'first_names', 'card_image']

    def create(self, validated_data):
        print(validated_data)
        return Visitor.objects.create_visitor(**validated_data)


class VisitorCrudSerializer(serializers.ModelSerializer):

    class Meta:
        model = Visitor
        fields = ['last_name', 'first_names', 'username', 'email', 'phone_number', 'sex', 'card_image']


class VisitCrudSerializer(serializers.ModelSerializer):

    class Meta:
        model = Visit
        fields = ['id', 'visitor', 'visit_start_date', 'visit_end_date']